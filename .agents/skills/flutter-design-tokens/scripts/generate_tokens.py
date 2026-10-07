#!/usr/bin/env python3
"""Render validated primitive design tokens to Dart. No third-party dependencies."""
import argparse
import json
import math
import os
from pathlib import Path
import re
import sys
import tempfile

GROUPS = {"space", "radius", "layout", "motion", "brand"}
RESERVED = set("abstract as assert async await base break case catch class const continue covariant default deferred do dynamic else enum export extends extension external factory false final finally for Function get hide if implements import in interface is late library mixin new null of on operator part required rethrow return sealed set show static super switch sync this throw true try typedef var void when while with yield".split())
RESERVED.update({"values", "index", "name", "hashCode", "runtimeType", "toString", "noSuchMethod"})


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def validate(data):
    if not isinstance(data, dict) or set(data) != GROUPS:
        raise ValueError("Expected exactly these groups: space, radius, layout, motion, brand")
    for group, entries in data.items():
        if not isinstance(entries, dict) or not entries:
            raise ValueError(f"{group} must be a non-empty object")
        for name, value in entries.items():
            if not re.fullmatch(r"[a-z][a-zA-Z0-9]*", name) or name in RESERVED or (group == "brand" and name == "seed"):
                raise ValueError(f"Invalid Dart token name: {group}.{name}")
            if group == "brand":
                if not isinstance(value, str) or not re.fullmatch(r"#[0-9a-fA-F]{6}", value):
                    raise ValueError(f"{group}.{name} must be #RRGGBB")
            elif group == "motion":
                if type(value) is not int or not 0 <= value <= 9223372036854775807:
                    raise ValueError(f"{group}.{name} must be a non-negative 64-bit integer in milliseconds")
            elif type(value) not in (int, float) or not math.isfinite(value) or value < 0:
                raise ValueError(f"{group}.{name} must be a finite non-negative number")
            elif group == "layout" and value == 0:
                raise ValueError(f"layout.{name} must be positive")


def render(data):
    validate(data)
    lines = ["// Generated primitive tokens. Review before integrating.",
             "import 'package:flutter/material.dart';", ""]
    for group, cls in (("space", "DsSpace"), ("radius", "DsRadius"), ("layout", "DsLayout")):
        lines.append(f"abstract final class {cls} {{")
        for name, value in data[group].items():
            literal = str(value) if type(value) is float or value <= 9223372036854775807 else str(float(value))
            lines.append(f"  static const double {name} = {literal};")
        lines.extend(["}", ""])
    lines.append("abstract final class DsMotion {")
    for name, value in data["motion"].items():
        lines.append(f"  static const Duration {name} = Duration(milliseconds: {value});")
    lines.extend(["}", "", "enum DsBrand {"])
    brands = list(data["brand"].items())
    for index, (name, color) in enumerate(brands):
        end = ";" if index == len(brands) - 1 else ","
        lines.append(f"  {name}(Color(0xFF{color[1:].upper()})){end}")
    lines.extend(["", "  const DsBrand(this.seed);", "  final Color seed;", "}", ""])
    return "\n".join(lines)


def write_output(path, content, force=False):
    path = Path(path)
    if path.exists() and not force:
        raise ValueError(f"Output exists: {path}. Use a new path or explicitly pass --force.")
    path.parent.mkdir(parents=True, exist_ok=True)
    if not force:
        with path.open("x", encoding="utf-8") as file:
            file.write(content)
        return
    # Validate/render first, then replace only after a complete temporary write.
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as file:
            temporary = Path(file.name)
            file.write(content)
        os.replace(temporary, path)
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", type=Path, help="Omit to print Dart to stdout")
    parser.add_argument("--force", action="store_true", help="Replace the explicitly selected output file")
    args = parser.parse_args()
    try:
        data = json.loads(args.input.read_text(encoding="utf-8"), object_pairs_hook=unique_object)
        result = render(data)
        if args.output:
            if args.input.resolve() == args.output.resolve():
                raise ValueError("Input and output must be different files")
            write_output(args.output, result, args.force)
        else:
            sys.stdout.write(result)
    except (OSError, ValueError, OverflowError) as error:
        parser.exit(2, f"Token generation failed: {error}\n")


if __name__ == "__main__":
    main()
