#!/usr/bin/env bash
# Pipeline dei dati per coppia vittima-autore, semestri 2025 (semestri.sh).
# Rilascio FOIA 2026 (riscontro del 15/05/2026, prot. MI-123-U-C-3-2-2026-88).
# 1. qsv: esporta in CSV i fogli dati dei due xlsx, senza pulizia
# 2. duckdb: normalizza e unisce i due semestri in un unico CSV
#
# I due xlsx dei semestri NON sono pubblicati in questo repository: contengono il
# codice persona SDI della vittima (ID_VITTIMA), lo stesso codice pubblicato nel
# file MI-123-U-A-SD-2025-90_6.xlsx insieme al comune. Per lo stesso motivo non è
# pubblicata la tabella di corrispondenza tra codice originale e codice nuovo.
# Lo script si può quindi eseguire solo disponendo di questi file, indicati con:
#
#   RAW_SEMESTRI    cartella con i due xlsx dei semestri
#   CODICI_VITTIMA  tabella di corrispondenza codici (codici_vittima.csv)
#
# Entrambi devono stare fuori dal repository. Gli export CSV intermedi, che
# contengono anch'essi i codici originali, sono scritti in una cartella
# temporanea cancellata a fine esecuzione.

set -euo pipefail

cartella="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
raw="${RAW_SEMESTRI:?indicare in RAW_SEMESTRI la cartella con i due xlsx dei semestri}"
codici="${CODICI_VITTIMA:?indicare in CODICI_VITTIMA la tabella codici_vittima.csv}"
processed="$cartella/data/output/2026/microdati_2025"
legende="$cartella/data/output/2026/legende"

xlsx_1="1 semestre 2025 (MI-123-U-C-3-2-2026-88_2).xlsx"
xlsx_2="2 semestre 2025 (MI-123-U-C-3-2-2026-88_3).xlsx"

fuori_repository() { [[ "$(realpath -m "$1")" != "$cartella"/* ]]; }
fuori_repository "$raw" || { echo "RAW_SEMESTRI deve stare fuori dal repository" >&2; exit 1; }
fuori_repository "$codici" || { echo "CODICI_VITTIMA deve stare fuori dal repository" >&2; exit 1; }
[[ -f "$codici" ]] || { echo "tabella dei codici non trovata: $codici" >&2; exit 1; }

csv="$(mktemp -d)"
trap 'rm -rf "$csv"' EXIT

mkdir -p "$processed"

# 1. Export CSV grezzo

qsv excel --sheet "Foglio1" -o "$csv/semestre_1_2025.csv" "$raw/$xlsx_1"

qsv excel --sheet "Sheet" -o "$csv/semestre_2_2025.csv" "$raw/$xlsx_2"

# 2. Normalizzazione e unione
# - spazi in testa e in coda rimossi
# - vuoti del 1° semestre e "(null)" del 2° diventano valori mancanti
# - date in formato ISO: il 1° semestre arriva già così da qsv, il 2° è gg.mm.aaaa
# - codici ed età come interi
# - colonne semestre (1 o 2) e fonte (nome dell'xlsx di origine)
# - duplicati esatti segnalati, non rimossi: n_copie (righe identiche nel
#   gruppo) e copia (progressivo nel gruppo; copia = 1 per tenerne una sola)
# - eta_vittima_anomala: età della vittima oltre 110 anni, valore non modificato
# - giorni_ammonimento, giorni_misura: giorni tra il fatto e l'esito, per
#   confrontare i semestri a parità di tempo (es. <= 30)
# - ID_VITTIMA sostituito con un codice senza significato (V00001...), letto
#   dalla tabella CODICI_VITTIMA: la stessa persona riceve sempre lo stesso codice
# - colonne *_descrizione accanto ai codici e reati_incerto, dalle legende in
#   data/output/2026/legende/
# - intestazioni delle colonne in minuscolo

duckdb -c "
create macro nz(x) as nullif(nullif(trim(x), ''), '(null)');
create macro data_iso(x) as coalesce(
  try_strptime(nz(x), '%Y-%m-%d'),
  try_strptime(nz(x), '%d.%m.%Y')
)::date;

create table grezzo as
select 1 as semestre, '$xlsx_1' as fonte, * from read_csv('$csv/semestre_1_2025.csv', all_varchar = true)
union all by name
select 2 as semestre, '$xlsx_2' as fonte, * from read_csv('$csv/semestre_2_2025.csv', all_varchar = true);

create table normalizzato as
select
  row_number() over () as ordine,
  semestre,
  fonte,
  nz(ID_VITTIMA) as ID_VITTIMA,
  nz(REATI) as REATI,
  data_iso(DATA_ACCADIMENTO) as DATA_ACCADIMENTO,
  nz(SESSO_AUTORE)::int as SESSO_AUTORE,
  nz(ETA_AUTORE)::int as ETA_AUTORE,
  nz(NAZIONE_NASCITA_AUTORE) as NAZIONE_NASCITA_AUTORE,
  nz(SEX_VITTIMA)::int as SEX_VITTIMA,
  nz(ETA_VITTIMA)::int as ETA_VITTIMA,
  nz(NAZIONE_NASCITA_VITTIMA) as NAZIONE_NASCITA_VITTIMA,
  nz(RELAZIONE_AUTORE_VITTIMA) as RELAZIONE_AUTORE_VITTIMA,
  nz(ESISTENZA_FIGLI_MINORI)::int as ESISTENZA_FIGLI_MINORI,
  nz(PRESENZA_FIGLI_MINORI)::int as PRESENZA_FIGLI_MINORI,
  nz(LUOGO_DEL_FATTO)::int as LUOGO_DEL_FATTO,
  nz(TIPOLOGIA_ARMA)::int as TIPOLOGIA_ARMA,
  data_iso(AMMONIMENTI) as AMMONIMENTI,
  data_iso(MISURE_SICUREZZA) as MISURE_SICUREZZA,
  data_iso(VIOLAZIONI) as VIOLAZIONI
from grezzo;

create table codici as select * from read_csv('$codici', all_varchar = true);

-- ogni vittima deve avere un codice: se ne manca uno la pipeline si ferma
create table verifica_codici as
select case when count(*) > 0
  then error('ID_VITTIMA senza codice in codici_vittima.csv: ' || count(*))
end
from normalizzato n anti join codici c on n.ID_VITTIMA = c.ID_VITTIMA_SDI;

update normalizzato n set ID_VITTIMA = c.ID_VITTIMA
from codici c where n.ID_VITTIMA = c.ID_VITTIMA_SDI;

create table legenda_reati as select * from read_csv('$legende/legenda_reati.csv', all_varchar = true);
create table legenda_codici as select * from read_csv('$legende/legenda_codici.csv', all_varchar = true);

create macro descrizione(nome_campo, valore) as (
  select descrizione from legenda_codici
  where campo = nome_campo and codice = valore::varchar
);

-- ogni codice presente deve avere una descrizione: se ne manca una la pipeline si ferma
create table verifica_legende as
select case when count(*) > 0
  then error('codici senza descrizione nelle legende: ' || string_agg(distinct campo || '=' || codice, ', '))
end
from (
  unpivot (
    select SESSO_AUTORE::varchar as SESSO_AUTORE, SEX_VITTIMA::varchar as SEX_VITTIMA,
      ESISTENZA_FIGLI_MINORI::varchar as ESISTENZA_FIGLI_MINORI, PRESENZA_FIGLI_MINORI::varchar as PRESENZA_FIGLI_MINORI,
      LUOGO_DEL_FATTO::varchar as LUOGO_DEL_FATTO, TIPOLOGIA_ARMA::varchar as TIPOLOGIA_ARMA
    from normalizzato
  ) on columns(*) into name campo value codice
) u
anti join legenda_codici l using (campo, codice)
union all
select case when count(*) > 0
  then error('codici reato senza descrizione: ' || string_agg(distinct REATI, ', '))
end
from normalizzato n anti join legenda_reati r on n.REATI = r.codice
where n.REATI is not null;

copy (
  select
    semestre,
    fonte,
    ID_VITTIMA,
    REATI,
    r.descrizione as REATI_DESCRIZIONE,
    r.incerto::boolean as REATI_INCERTO,
    DATA_ACCADIMENTO,
    SESSO_AUTORE,
    descrizione('SESSO_AUTORE', SESSO_AUTORE) as SESSO_AUTORE_DESCRIZIONE,
    ETA_AUTORE,
    NAZIONE_NASCITA_AUTORE,
    SEX_VITTIMA,
    descrizione('SEX_VITTIMA', SEX_VITTIMA) as SEX_VITTIMA_DESCRIZIONE,
    ETA_VITTIMA,
    NAZIONE_NASCITA_VITTIMA,
    RELAZIONE_AUTORE_VITTIMA,
    ESISTENZA_FIGLI_MINORI,
    descrizione('ESISTENZA_FIGLI_MINORI', ESISTENZA_FIGLI_MINORI) as ESISTENZA_FIGLI_MINORI_DESCRIZIONE,
    PRESENZA_FIGLI_MINORI,
    descrizione('PRESENZA_FIGLI_MINORI', PRESENZA_FIGLI_MINORI) as PRESENZA_FIGLI_MINORI_DESCRIZIONE,
    LUOGO_DEL_FATTO,
    descrizione('LUOGO_DEL_FATTO', LUOGO_DEL_FATTO) as LUOGO_DEL_FATTO_DESCRIZIONE,
    TIPOLOGIA_ARMA,
    descrizione('TIPOLOGIA_ARMA', TIPOLOGIA_ARMA) as TIPOLOGIA_ARMA_DESCRIZIONE,
    AMMONIMENTI,
    MISURE_SICUREZZA,
    VIOLAZIONI,
    count(*) over riga_uguale as n_copie,
    row_number() over (riga_uguale order by ordine) as copia,
    ETA_VITTIMA > 110 as eta_vittima_anomala,
    AMMONIMENTI - DATA_ACCADIMENTO as giorni_ammonimento,
    MISURE_SICUREZZA - DATA_ACCADIMENTO as giorni_misura
  from normalizzato n
  left join legenda_reati r on n.REATI = r.codice
  window riga_uguale as (
    partition by semestre, fonte, ID_VITTIMA, REATI, DATA_ACCADIMENTO,
      SESSO_AUTORE, ETA_AUTORE, NAZIONE_NASCITA_AUTORE, SEX_VITTIMA, ETA_VITTIMA,
      NAZIONE_NASCITA_VITTIMA, RELAZIONE_AUTORE_VITTIMA, ESISTENZA_FIGLI_MINORI,
      PRESENZA_FIGLI_MINORI, LUOGO_DEL_FATTO, TIPOLOGIA_ARMA, AMMONIMENTI,
      MISURE_SICUREZZA, VIOLAZIONI
  )
  order by ordine
) to '$processed/2025.csv' (header, delimiter ',');
"

# intestazioni in minuscolo, come da convenzione del repository
sed -i '1s/.*/\L&/' "$processed/2025.csv"

"$cartella/scripts/2026/verifica_identificativi.sh" "$processed"
