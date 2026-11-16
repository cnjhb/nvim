"""Generate compile_commands.json for clangd from a Keil uVision project.

Keil MDK builds with ARM Compiler, which clangd cannot read.  This script
extracts the selected target's defines, include paths and sources from the
.uvprojx and writes a compilation database clangd can use.

It works for any Keil project, not just this one:

    python uvprojx2cdb.py                  # auto-detect the project from the cwd
    python uvprojx2cdb.py -p path/to/Proj  # explicit directory or .uvprojx
    python uvprojx2cdb.py --target GD32F107RC

The database is written next to the sources (normally the .uvprojx directory).
Only C sources are listed; assembly startup files are skipped.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


def find_project(start: Path) -> Path | None:
    """Find a .uvprojx at or above `start`, then below it."""
    for base in [start, *start.parents]:
        hits = sorted(base.glob("*.uvprojx"))
        if hits:
            return hits[0].resolve()
    hits = sorted(start.rglob("*.uvprojx"))
    return hits[0].resolve() if hits else None


def find_armcc_include() -> Path | None:
    """Locate an ARM Compiler include directory (stdio.h, string.h, ...)."""
    roots = []
    local = os.environ.get("LOCALAPPDATA")
    if local:
        roots.append(Path(local) / "Keil_v5" / "ARM")
    roots += [Path(r"C:\Keil_v5\ARM"), Path(r"C:\Keil\ARM")]
    for root in roots:
        if not root.is_dir():
            continue
        # ARMCLANG (v6) headers are clang based and parse most cleanly
        for child in sorted(root.iterdir(), reverse=True):
            inc = child / "include"
            if (inc / "stdio.h").is_file():
                return inc
    return None


def clangd_cache_dir() -> Path:
    """Return a per-user cache directory outside the project and this repo."""
    local = os.environ.get("LOCALAPPDATA")
    if local:
        # Keep this outside the Neovim config directory, which is itself
        # %LOCALAPPDATA%\nvim on Windows.
        return Path(local) / "keil-clangd-cache"
    xdg = os.environ.get("XDG_CACHE_HOME")
    if xdg:
        return Path(xdg) / "keil-clangd"
    return Path.home() / ".cache" / "keil-clangd"


def ensure_sys_time_shim() -> Path | None:
    """Create the clangd-only sys/time.h lwIP expects on the GNU path.

    Arm Compiler 6 defines __GNUC__ but does not ship sys/time.h.  Keeping
    the shim in the cache avoids adding a fake system header to the repo.
    """
    try:
        include = clangd_cache_dir() / "clangd_include"
        target = include / "sys" / "time.h"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(
            "/* clangd-only shim for Keil lwIP projects. */\n"
            "#ifndef KEIL_CLANGD_SYS_TIME_H\n"
            "#define KEIL_CLANGD_SYS_TIME_H\n"
            "#include <time.h>\n"
            "struct timeval { long tv_sec; long tv_usec; };\n"
            "#endif\n",
            encoding="utf-8",
        )
        return include
    except OSError:
        return None


def text(node: ET.Element, tag: str, default: str = "") -> str:
    found = node.find(tag)
    if found is None or found.text is None:
        return default
    return found.text.strip()


def split_list(raw: str) -> list[str]:
    return [p.strip() for p in re.split(r"[;,]", raw) if p.strip()]


def pick_target(targets: list[ET.Element], wanted: str | None) -> ET.Element | None:
    if wanted:
        return next((t for t in targets if text(t, "TargetName") == wanted), None)
    return targets[0] if targets else None


def choose_output_dir(project_file: Path, sources: list[Path]) -> Path:
    """Put the database where clangd will find it from every source file."""
    proj_dir = project_file.parent
    if not sources:
        return proj_dir
    try:
        common = Path(os.path.commonpath([str(s.parent) for s in sources]))
    except ValueError:
        return proj_dir
    # never place the database more than two levels above the project file
    try:
        depth = len(proj_dir.relative_to(common).parts)
    except ValueError:
        return proj_dir
    return common if depth <= 2 else proj_dir


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--project", default=None,
                        help="project directory or .uvprojx file (default: auto-detect)")
    parser.add_argument("-t", "--target", default=None, help="Keil target name")
    parser.add_argument("-o", "--output", default=None,
                        help="output directory or file (default: next to the sources)")
    parser.add_argument("--armcc-include", default=None,
                        help="ARM Compiler include dir for the C library headers")
    parser.add_argument("--list-targets", action="store_true", help="print targets and exit")
    args = parser.parse_args()

    if args.project:
        start = Path(args.project).resolve()
        project_file = start if start.is_file() else find_project(start)
    else:
        project_file = find_project(Path.cwd().resolve())

    if project_file is None or not project_file.is_file():
        print("no .uvprojx found; pass -p <dir or file>", file=sys.stderr)
        return 1

    tree = ET.parse(project_file)
    targets = tree.getroot().findall("./Targets/Target")
    if args.list_targets:
        for t in targets:
            print(text(t, "TargetName"))
        return 0

    target = pick_target(targets, args.target)
    if target is None:
        names = ", ".join(text(t, "TargetName") for t in targets)
        print(f"target {args.target!r} not found; available: {names}", file=sys.stderr)
        return 1
    target_name = text(target, "TargetName")

    ads = target.find("./TargetOption/TargetArmAds/Cads/VariousControls")
    defines: list[str] = []
    includes: list[Path] = []
    if ads is not None:
        defines = split_list(text(ads, "Define"))
        for raw in split_list(text(ads, "IncludePath")):
            path = (project_file.parent / raw).resolve()
            if path.is_dir():
                includes.append(path)

    armcc_include = Path(args.armcc_include) if args.armcc_include else find_armcc_include()
    if armcc_include is not None and not armcc_include.is_dir():
        armcc_include = None

    # Arm Compiler 6 defines __GNUC__ but does not ship sys/time.h, which
    # lwIP's cc.h includes on the GNU path.  Generate the shim in the user
    # cache so it never becomes part of the project or this repository.
    shim_include = ensure_sys_time_shim()

    sources: list[Path] = []
    for entry in target.findall("./Groups/Group/Files/File"):
        if text(entry, "./FileOption/CommonProperty/IncludeInBuild", "1") == "0":
            continue
        name = text(entry, "FileName")
        if not name.lower().endswith(".c"):
            continue
        source = (project_file.parent / text(entry, "FilePath")).resolve()
        if source.is_file():
            sources.append(source)
        else:
            print(f"skip missing source: {source}", file=sys.stderr)

    common = [
        "clang",
        "-xc",
        "-std=c99",
        "--target=armv7m-none-eabi",
        "-mcpu=cortex-m3",
        "-mthumb",
        "-fno-short-enums",
    ]
    common += [f"-D{d}" for d in defines]
    common += [f"-I{inc}" for inc in includes]
    if armcc_include is not None:
        common.append(f"-isystem{armcc_include}")
        # Make AC6-only branches visible to clangd.  Without this, code such
        # as `#if (__ARMCC_VERSION >= 6010050)` falls into the AC5 fallback
        # and can redeclare types that armclang's own headers already define.
        if "ARMCLANG" in str(armcc_include).upper():
            common.append("-D__ARMCC_VERSION=6220000")
    if shim_include is not None:
        common.append(f"-isystem{shim_include}")
    common += [
        "-Wno-unknown-attributes",
        "-Wno-ignored-attributes",
        "-Wno-macro-redefined",
        # armcc keywords used by the RVDS FreeRTOS port and CMSIS
        "-D__forceinline=__inline__",
        "-D__weak=__attribute__((weak))",
        "-D__packed=__attribute__((packed))",
        "-D__align(x)=__attribute__((aligned(x)))",
        "-D__dsb(x)=__builtin_arm_dsb(x)",
        "-D__isb(x)=__builtin_arm_isb(x)",
    ]

    if args.output:
        out = Path(args.output).resolve()
        out_file = out if out.suffix.lower() == ".json" else out / "compile_commands.json"
    else:
        out_file = choose_output_dir(project_file, sources) / "compile_commands.json"

    entries = []
    for source in sources:
        obj = source.with_suffix(".o")
        entries.append(
            {
                "directory": str(project_file.parent),
                "file": str(source),
                "output": str(obj),
                "arguments": common + ["-c", str(source), "-o", str(obj)],
            }
        )

    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text(json.dumps(entries, indent=2) + "\n", encoding="utf-8")

    print(f"project: {project_file}")
    print(f"target:  {target_name}" + ("" if args.target else f" (first of {len(targets)})"))
    print(f"output:  {out_file} ({len(entries)} files)")
    print(f"armcc:   {armcc_include if armcc_include else 'not found'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
