#!/usr/bin/env bash
# auditoria de ids de dialogo: lista los ids ya usados (case + ShowPlayerDialog*)
# en todo gamemodes/ y calcula los ids libres en 1-200. existe porque durante
# la tanda 3 de #15 casi se manda un dialogo con un id (175-182) que el sistema
# de teles ya tenia, solo se salvo porque el revisor lo cacho - no queremos
# que vuelva a pasar.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

echo "=== case N: en cualquier dispatcher (main, teles, bombas, sistemas, etc.) ==="
# solo case que aparezcan dentro de un switch(dialogid), filtrando falsos positivos
# de switch(row), switch(listitem), etc. rastreamos llaves para saber cuando
# termina el bloque del switch.
> "$WORK/case_ids.txt"
DISPATCHER_FILES=$(grep -rlE "On[A-Za-z]*DialogResponse" gamemodes/ --include="*.pwn" | sort -u)
for f in $DISPATCHER_FILES; do
  awk '
    BEGIN { in_dlg = 0; depth = 0 }
    {
      line = $0
      if (in_dlg == 0 && line ~ /switch[[:space:]]*\([[:space:]]*dialogid[[:space:]]*\)/) {
        in_dlg = 1
        # contar la llave de apertura de la linea del switch, si esta
        n = gsub(/\{/, "{", line); depth += n
        # tambien puede haber { en lineas siguientes del cuerpo
        next
      }
      if (in_dlg == 1) {
        n_open  = gsub(/\{/, "{", line)
        n_close = gsub(/\}/, "}", line)
        depth += n_open - n_close
        if (depth <= 0 && (n_open + n_close) > 0) { in_dlg = 0; next }
        if (line ~ /^[[:space:]]*case[[:space:]]+[0-9]+:/) {
          match(line, /[0-9]+/); print substr(line, RSTART, RLENGTH)
        }
      }
    }
  ' "$f"
done | sort -un > "$WORK/case_ids.txt"
cat "$WORK/case_ids.txt"
echo

echo "=== ShowPlayerDialog(Ex)?(playerid, N, ...) en cualquier archivo ==="
grep -rEn "ShowPlayerDialog(Ex)?\(playerid, [0-9]+," gamemodes/ \
  | awk -F'playerid, ' '{print $2}' | awk -F',' '{print $1}' | sort -un > "$WORK/dialog_ids.txt"
cat "$WORK/dialog_ids.txt"
echo

cat "$WORK/case_ids.txt" "$WORK/dialog_ids.txt" | sort -un > "$WORK/all_used.txt"

echo "=== union (case + ShowPlayerDialog) - todos los ids ya usados ==="
cat "$WORK/all_used.txt"
echo

echo "=== ids libres en 1-200 ==="
seq 1 200 | awk 'NR==FNR{a[$1]=1;next}!a[$1]{print}' "$WORK/all_used.txt" -
echo

echo "=== para verificar un id especifico: pasalo como argumento (ej: $0 142) ==="
if [ "${1:-}" != "" ]; then
  ID="$1"
  echo "-- busqueda del id $ID en todo el codigo preexistente --"
  if grep -qE "^${ID}\$" "$WORK/all_used.txt"; then
    echo "OCUPADO: el id $ID ya esta en uso. ubicaciones:"
    grep -rEn "case ${ID}:|ShowPlayerDialog(Ex)?\(playerid, ${ID}," gamemodes/ || true
  else
    echo "LIBRE: el id $ID no aparece en ningun case ni ShowPlayerDialog del codigo."
  fi
fi
