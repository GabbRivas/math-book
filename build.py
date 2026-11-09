#!/usr/bin/env python3
"""build.py: compile the document with the fonts in ./fonts (and only those).

Usage (from this folder):
  python build.py pdf                      light theme  -> build/book-paper.pdf
  python build.py pdf --theme night        dark theme   -> build/book-night.pdf
  python build.py pdf --draft              show the grid (rail / text / note columns)
  python build.py pdf specimen.typ         compile another file
  python build.py watch                    recompile on every save
  python build.py png --pages 1-3          PNG previews in build/png/
  python build.py fonts                    check that Typst sees every font
  python build.py clean                    delete build/

Options can be combined: python build.py pdf --theme night --format square --open
Only the Python standard library is used; works on Windows, macOS and Linux.
"""
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FONTS = ROOT / "fonts"
OUT = ROOT / "build"
REQUIRED_FONTS = ["STIX Two Text", "STIX Two Math", "Bodoni Moda"]


def typst() -> str:
    exe = shutil.which("typst")
    if exe is None:
        sys.exit("Typst is not on your PATH. On Windows: winget install --id Typst.Typst")
    return exe


def font_args(a: argparse.Namespace) -> list[str]:
    args = ["--font-path", str(FONTS)]
    if not a.system_fonts:
        args.append("--ignore-system-fonts")   # same fonts on every machine
    return args


def input_args(a: argparse.Namespace) -> list[str]:
    pairs = [f"theme={a.theme}", f"format={a.format}", f"draft={'true' if a.draft else 'false'}", *a.input]
    args: list[str] = []
    for kv in pairs:
        args += ["--input", kv]
    return args


def run(cmd: list[str]) -> int:
    print(">", " ".join(cmd))
    try:
        return subprocess.call(cmd)
    except KeyboardInterrupt:      # Ctrl+C stops `watch` cleanly
        return 0


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("cmd", choices=["pdf", "watch", "png", "svg", "fonts", "clean"])
    p.add_argument("file", nargs="?", default="book.typ", help="the .typ file to compile (default: book.typ)")
    p.add_argument("--theme", default="paper", choices=["paper", "night"])
    p.add_argument("--format", default="landscape", choices=["landscape", "portrait", "square"])
    p.add_argument("--draft", action="store_true", help="show the grid")
    p.add_argument("--input", action="append", default=[], metavar="KEY=VALUE", help="extra sys.inputs")
    p.add_argument("--system-fonts", action="store_true", help="also allow fonts installed on this computer")
    p.add_argument("--pages", help='e.g. "1-3" or "2,5-"')
    p.add_argument("--ppi", type=int, default=144, help="resolution for png (default 144)")
    p.add_argument("--open", action="store_true", help="open the PDF when done")
    a = p.parse_args()

    if a.cmd == "clean":
        shutil.rmtree(OUT, ignore_errors=True)
        print("removed", OUT)
        return

    if a.cmd == "fonts":
        res = subprocess.run([typst(), "fonts", *font_args(a)], capture_output=True, text=True, encoding="utf-8")
        print(res.stdout)
        found = {line.strip() for line in res.stdout.splitlines()}
        missing = [f for f in REQUIRED_FONTS if f not in found]
        sys.exit(f"Missing fonts: {', '.join(missing)}" if missing else "All required fonts found.")

    src = (ROOT / a.file).resolve()
    if not src.exists():
        sys.exit(f"No such file: {src}")
    stem = f"{src.stem}-{a.theme}" + ("" if a.format == "landscape" else f"-{a.format}") + ("-draft" if a.draft else "")
    OUT.mkdir(exist_ok=True)

    cmd = [typst(), "watch" if a.cmd == "watch" else "compile", "--root", str(ROOT), *font_args(a), *input_args(a)]
    if a.pages:
        cmd += ["--pages", a.pages]

    if a.cmd in ("pdf", "watch"):
        if a.open:
            cmd.append("--open")
        sys.exit(run([*cmd, str(src), str(OUT / f"{stem}.pdf")]))

    # png / svg: one file per page
    out_dir = OUT / a.cmd
    out_dir.mkdir(exist_ok=True)
    if a.cmd == "png":
        cmd += ["--ppi", str(a.ppi)]
    sys.exit(run([*cmd, str(src), str(out_dir / f"{stem}-{{0p}}.{a.cmd}")]))


if __name__ == "__main__":
    main()
