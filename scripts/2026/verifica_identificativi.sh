#!/usr/bin/env bash
# Controllo: nessun codice persona SDI nei percorsi pubblicati del rilascio 2026.
# Cerca le due forme del codice: aaaa-mm-gg-hh.mm.ss.microsecondi (ID_VITTIMA dei
# file semestrali) e la stessa sequenza di 20 cifre senza separatori (COD_VITTIMA
# del rilascio 2025). Esce con errore e stampa i file se ne trova.
#
# Uso: verifica_identificativi.sh [percorso ...]
# Senza argomenti controlla data/output/2026 e data/rawdata/2026.

set -euo pipefail

cartella="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [[ $# -gt 0 ]]; then
  percorsi=("$@")
else
  percorsi=("$cartella/data/output/2026" "$cartella/data/rawdata/2026")
fi

schema='[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.[0-9]{6}|(^|[^0-9])[0-9]{20}([^0-9]|$)'

trovati="$(grep -rlE --include='*.csv' --include='*.sql' --include='*.md' --include='*.txt' "$schema" "${percorsi[@]}" || true)"

if [[ -n "$trovati" ]]; then
  echo "codici persona SDI trovati in:" >&2
  echo "$trovati" >&2
  exit 1
fi

echo "verifica identificativi: nessun codice persona SDI"
