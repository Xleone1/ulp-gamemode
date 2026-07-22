#!/usr/bin/env python3
"""Check .pwn files for U+FFFD (replacement character) from encoding mismatches."""
import sys
from pathlib import Path

def check_file(path):
    data = path.read_bytes()
    count = data.count(b'\xef\xbf\xbd')
    if count:
        print(f"WARNING: {path} — {count} U+FFFD characters found (should be W1252)")
        return 1
    return 0

def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    errors = 0
    for f in sorted(root.rglob("*.pwn")):
        errors += check_file(f)
    if errors:
        print(f"\n{errors} file(s) contain U+FFFD — convert to Windows-1252")
    else:
        print("OK — no U+FFFD found in any .pwn file")
    return errors

if __name__ == "__main__":
    sys.exit(main())
