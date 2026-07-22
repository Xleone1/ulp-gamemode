#!/usr/bin/env python3
"""
auditoria de ids de dialogo: lista los ids ya usados (case + ShowPlayerDialog*)
en todo gamemodes/ y calcula los ids libres en 1-200. existe porque durante
la tanda 3 de #15 casi se manda un dialogo con un id (175-182) que el sistema
de teles ya tenia, solo se salvo porque el revisor lo cacho - no queremos
que vuelva a pasar.

uso:
    python3 tools/dialog_id_audit.py           # auditoria completa
    python3 tools/dialog_id_audit.py 142       # chequea un id especifico
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
GAMEMODES = REPO_ROOT / "gamemodes"

DISPATCHER_RE = re.compile(r"On[A-Za-z]*DialogResponse")
SWITCH_DLG_RE = re.compile(r"switch\s*\(\s*dialogid\s*\)")
CASE_RE = re.compile(r"^\s*case\s+(\d+):")
DIALOG_CALL_RE = re.compile(r"ShowPlayerDialog(Ex)?\(playerid,\s*(\d+),")
DIALOG_RANGE = range(1, 201)


def find_pwn_files(root: Path) -> list[Path]:
    return sorted(root.rglob("*.pwn"))


def find_dispatcher_files(root: Path) -> list[Path]:
    """solo archivos .pwn que tengan un OnXxxDialogResponse declarado."""
    out: list[Path] = []
    for p in find_pwn_files(root):
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        if DISPATCHER_RE.search(text):
            out.append(p)
    return out


def extract_case_ids(path: Path) -> set[int]:
    """
    devuelve los ids que aparecen como 'case N:' dentro de un switch(dialogid)
    en este archivo. rastrea la profundidad de llaves para saber cuando
    termina el bloque del switch, asi no cazamos falsos positivos de
    switch(row), switch(listitem), etc.
    """
    ids: set[int] = set()
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return ids

    in_dlg = False
    depth = 0
    for line in text.splitlines():
        if not in_dlg:
            if SWITCH_DLG_RE.search(line):
                in_dlg = True
                depth += line.count("{") - line.count("}")
            continue

        depth += line.count("{") - line.count("}")
        if depth <= 0 and ("{" in line or "}" in line):
            in_dlg = False
            continue

        m = CASE_RE.match(line)
        if m:
            ids.add(int(m.group(1)))

    return ids


def extract_dialog_call_ids(root: Path) -> set[int]:
    """devuelve todos los ids que aparecen en ShowPlayerDialog(Ex)?(playerid, N, ...)"""
    ids: set[int] = set()
    for p in find_pwn_files(root):
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for m in DIALOG_CALL_RE.finditer(text):
            ids.add(int(m.group(2)))
    return ids


def find_id_locations(root: Path, dialog_id: int) -> list[tuple[str, int, str]]:
    """devuelve (archivo, linea, contenido) para cada uso del id dado."""
    out: list[tuple[str, int, str]] = []
    pat_case = re.compile(rf"case\s+{dialog_id}\s*:")
    pat_call = re.compile(rf"ShowPlayerDialog(Ex)?\(playerid,\s*{dialog_id},")
    for p in find_pwn_files(root):
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for i, line in enumerate(text.splitlines(), start=1):
            if pat_case.search(line) or pat_call.search(line):
                rel = p.relative_to(REPO_ROOT)
                out.append((str(rel), i, line))
    return out


def main(argv: list[str]) -> int:
    if not GAMEMODES.is_dir():
        print(f"error: no se encontro el directorio {GAMEMODES}", file=sys.stderr)
        return 2

    # si pasan un id como argumento, hace solo el chequeo puntual y sale
    if len(argv) > 1:
        try:
            target = int(argv[1])
        except ValueError:
            print(f"error: argumento '{argv[1]}' no es un entero", file=sys.stderr)
            return 2
        case_ids: set[int] = set()
        for f in find_dispatcher_files(GAMEMODES):
            case_ids |= extract_case_ids(f)
        dialog_ids = extract_dialog_call_ids(GAMEMODES)
        used = case_ids | dialog_ids
        print(f"=== chequeo del id {target} ===")
        if target in used:
            print(f"OCUPADO: el id {target} ya esta en uso. ubicaciones:")
            for path, line, content in find_id_locations(GAMEMODES, target):
                print(f"{path}:{line}:{content}")
        else:
            print(f"LIBRE: el id {target} no aparece en ningun case ni ShowPlayerDialog del codigo.")
        return 0

    # si no pasaron argumento, hace la auditoria completa
    print("=== case N: en cualquier dispatcher (main, teles, bombas, sistemas, etc.) ===")
    case_ids = set()
    for f in find_dispatcher_files(GAMEMODES):
        case_ids |= extract_case_ids(f)
    for i in sorted(case_ids):
        print(i)
    print()

    print("=== ShowPlayerDialog(Ex)?(playerid, N, ...) en cualquier archivo ===")
    dialog_ids = extract_dialog_call_ids(GAMEMODES)
    for i in sorted(dialog_ids):
        print(i)
    print()

    used = case_ids | dialog_ids
    print("=== union (case + ShowPlayerDialog) - todos los ids ya usados ===")
    for i in sorted(used):
        print(i)
    print()

    print("=== ids libres en 1-200 ===")
    free = [i for i in DIALOG_RANGE if i not in used]
    for i in free:
        print(i)
    print()

    print("=== para chequear un id especifico: pasalo como argumento (ej: python3 tools/dialog_id_audit.py 142) ===")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
