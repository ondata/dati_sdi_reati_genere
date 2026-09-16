#!/usr/bin/env bash
# Serie provinciale 2019-2025 (serie_provinciale.sh).
# Unisce i due rilasci FOIA degli aggregati:
# - primo FOIA (istanza 18/04/2025, risposta 09/05/2025): anni 2019-2024
# - secondo FOIA (istanza 16/04/2026, risposta 15/05/2026): anni 2024-2025
# Per il 2024, presente in entrambi, il file principale tiene il valore del
# rilascio più recente; le differenze finiscono in revisioni_2024.csv.
#
# Richiede che aggregati.sh sia già stato eseguito: legge il suo output.
# Il file del primo rilascio è quello già pubblicato in data/rawdata/.

set -euo pipefail

cartella="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
raw="$cartella/data/rawdata"
csv="$cartella/data/processing/2026/serie_2019_2024"
aggregati="$cartella/data/output/2026/aggregati_2024_2025"
processed="$cartella/data/output/2026/serie_2019_2025"
legende="$cartella/data/output/2026/legende"

xlsx="MI-123-U-A-SD-2025-90_5.xlsx"
nuovo="$aggregati/aggregati_2024_2025.csv"

mkdir -p "$csv" "$processed"

if [[ ! -f "$nuovo" ]]; then
  echo "manca $nuovo: eseguire prima scripts/2026/aggregati.sh" >&2
  exit 1
fi

# 1. Export CSV grezzo del primo rilascio
# intestazione su riga 2, tranne le segnalazioni che ce l'hanno su due righe
# (anno sopra, sesso sotto) e partono dalla 3

esporta() { qsv excel --sheet "$1" --header-row "$2" -q -o "$csv/$3.csv" "$raw/$xlsx"; }

esporta "Omicidi DCPC"                2 omicidi_dcpc
esporta "Delitti - Commessi"          2 delitti_commessi
esporta "Delitti - Vittime"           2 delitti_vittime
esporta "Delitti - Segnalazioni"      3 delitti_segnalazioni
esporta "Reati spia - Commessi"       2 reati_spia_commessi
esporta "Reati spia - Vittime"        2 reati_spia_vittime
esporta "Reati spia - Segnalazioni"   3 reati_spia_segnalazioni
esporta "Codice Rosso - Commessi"     2 codice_rosso_commessi
esporta "Codice Rosso - Vittime"      2 codice_rosso_vittime
esporta "Codice Rosso - Segnalazioni" 3 codice_rosso_segnalazioni

# 2. Serie unica
# - stessa struttura dell'output di aggregati.sh, con in più le colonne
#   rilascio (2025 o 2026) e anno_parziale
# - anno_parziale è vero per il 2019 dei reati del Codice Rosso: la legge è
#   dell'agosto 2019, quindi l'anno copre solo una parte del periodo (nel
#   foglio la colonna si chiama "2019*")
# - i quattro reati del Codice Rosso hanno etichette diverse nei due rilasci e
#   sono ricondotti con data/output/2026/legende/reati_alias.csv

duckdb -c "
create macro leggi(file, nomi) as table
  select * from read_csv(file, header = false, all_varchar = true, names = nomi);

create table alias_reati as select * from read_csv('$legende/reati_alias.csv', all_varchar = true);
create macro reato_norm(x) as coalesce(
  (select reato_2024_2025 from alias_reati where reato_2019_2024 = trim(x)), trim(x));

-- la provincia del primo rilascio usa qualche nome diverso (es. PESARO)
create table alias_province as select * from read_csv('$legende/province_alias.csv', all_varchar = true);
create macro provincia_norm(x) as coalesce(
  (select p.provincia from read_csv('$nuovo') p
    join alias_province a on upper(strip_accents(a.den_uts_istat)) = upper(strip_accents(p.provincia_istat))
   where a.provincia_file = trim(x) limit 1), trim(x));

create table anni(col varchar, anno int);
insert into anni values ('v2019',2019),('v2020',2020),('v2021',2021),('v2022',2022),('v2023',2023),('v2024',2024);

create table vecchio as
with commessi as (
  select 'Delitti' as gruppo, provincia, reato, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/delitti_commessi.csv', ['provincia','reato','v2019','v2020','v2021','v2022','v2023','v2024'])
  union all by name
  select 'Reati spia' as gruppo, provincia, reato, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/reati_spia_commessi.csv', ['provincia','reato','v2019','v2020','v2021','v2022','v2023','v2024'])
  union all by name
  select 'Codice Rosso' as gruppo, provincia, reato, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/codice_rosso_commessi.csv', ['provincia','reato','v2019','v2020','v2021','v2022','v2023','v2024'])
),
vittime as (
  select 'Delitti' as gruppo, provincia, reato, fascia_eta, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/delitti_vittime.csv', ['provincia','reato','fascia_eta','v2019','v2020','v2021','v2022','v2023','v2024'])
  union all by name
  select 'Reati spia' as gruppo, provincia, reato, fascia_eta, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/reati_spia_vittime.csv', ['provincia','reato','fascia_eta','v2019','v2020','v2021','v2022','v2023','v2024'])
  union all by name
  select 'Codice Rosso' as gruppo, provincia, reato, fascia_eta, v2019, v2020, v2021, v2022, v2023, v2024
  from leggi('$csv/codice_rosso_vittime.csv', ['provincia','reato','fascia_eta','v2019','v2020','v2021','v2022','v2023','v2024'])
),
segnalazioni_larghe as (
  select 'Delitti' as gruppo, * from leggi('$csv/delitti_segnalazioni.csv', ['provincia','reato','fascia_eta','f2019','m2019','f2020','m2020','f2021','m2021','f2022','m2022','f2023','m2023','f2024','m2024'])
  union all by name
  select 'Reati spia' as gruppo, * from leggi('$csv/reati_spia_segnalazioni.csv', ['provincia','reato','fascia_eta','f2019','m2019','f2020','m2020','f2021','m2021','f2022','m2022','f2023','m2023','f2024','m2024'])
  union all by name
  select 'Codice Rosso' as gruppo, * from leggi('$csv/codice_rosso_segnalazioni.csv', ['provincia','reato','fascia_eta','f2019','m2019','f2020','m2020','f2021','m2021','f2022','m2022','f2023','m2023','f2024','m2024'])
),
segnalazioni as (
  select gruppo, provincia, reato, fascia_eta, sesso_autore,
    case sesso_autore when 'FEMMINILE' then f2019 else m2019 end as v2019,
    case sesso_autore when 'FEMMINILE' then f2020 else m2020 end as v2020,
    case sesso_autore when 'FEMMINILE' then f2021 else m2021 end as v2021,
    case sesso_autore when 'FEMMINILE' then f2022 else m2022 end as v2022,
    case sesso_autore when 'FEMMINILE' then f2023 else m2023 end as v2023,
    case sesso_autore when 'FEMMINILE' then f2024 else m2024 end as v2024
  from segnalazioni_larghe
  cross join (select unnest(['FEMMINILE','MASCHILE']) as sesso_autore)
),
tutto as (
  select gruppo, 'reati commessi' as misura, provincia, reato, null as fascia_eta, null as sesso_autore, v2019, v2020, v2021, v2022, v2023, v2024 from commessi
  union all by name
  select gruppo, 'vittime' as misura, provincia, reato, fascia_eta, null as sesso_autore, v2019, v2020, v2021, v2022, v2023, v2024 from vittime
  union all by name
  select gruppo, 'segnalazioni' as misura, provincia, reato, fascia_eta, sesso_autore, v2019, v2020, v2021, v2022, v2023, v2024 from segnalazioni
)
-- in un foglio la stessa provincia compare con due nomi (PESARO e
-- PESARO E URBINO): dopo la normalizzazione le righe si sommano
select gruppo, misura, provincia, reato, fascia_eta, sesso_autore, anno, sum(valore) as valore
from (
  select gruppo, misura, provincia_norm(provincia) as provincia, reato_norm(reato) as reato,
    trim(fascia_eta) as fascia_eta, trim(sesso_autore) as sesso_autore,
    (select anno from anni where anni.col = colonna) as anno,
    nullif(trim(valore), '')::int as valore
  from tutto
  unpivot (valore for colonna in (v2019, v2020, v2021, v2022, v2023, v2024))
  where provincia is not null and reato is not null
)
group by all;

-- il nuovo rilascio, già normalizzato da aggregati.sh
create table nuovo as select * from read_csv('$nuovo');

-- nel 2024 una combinazione può esistere in un rilascio e non nell'altro
-- (tipicamente valori a zero): non è un errore, finisce in revisioni_2024.csv
-- con la colonna presenza

copy (
  select gruppo, misura, provincia, cod_provincia_istat, provincia_istat, codice_provincia_storico, codice_regione, regione, ripartizione_geografica, perimetro_confrontabile,
    num_ordine, reato, fascia_eta, sesso_autore, anno, valore,
    2026 as rilascio, false as anno_parziale
  from nuovo
  union all by name
  select v.gruppo, v.misura, v.provincia, p.cod_provincia_istat, p.provincia_istat, p.codice_provincia_storico,
    p.codice_regione, p.regione, p.ripartizione_geografica, p.perimetro_confrontabile,
    o.num_ordine, v.reato, v.fascia_eta, v.sesso_autore, v.anno, v.valore,
    2025 as rilascio,
    (v.gruppo = 'Codice Rosso' and v.anno = 2019) as anno_parziale
  from vecchio v
  left join (
    select distinct provincia, cod_provincia_istat, provincia_istat, codice_provincia_storico, codice_regione, regione, ripartizione_geografica, perimetro_confrontabile from nuovo
  ) p on p.provincia = v.provincia
  left join (
    select distinct gruppo, reato, num_ordine from nuovo where num_ordine is not null
  ) o on o.gruppo = v.gruppo and o.reato = v.reato
  where v.anno < 2024 and v.valore is not null
  order by gruppo, misura, provincia, reato, fascia_eta, sesso_autore, anno
) to '$processed/province_2019_2025.csv' (header, delimiter ',');

copy (
  select coalesce(v.gruppo, n.gruppo) as gruppo, coalesce(v.misura, n.misura) as misura,
    coalesce(v.provincia, n.provincia) as provincia, coalesce(v.reato, n.reato) as reato,
    coalesce(v.fascia_eta, n.fascia_eta) as fascia_eta, coalesce(v.sesso_autore, n.sesso_autore) as sesso_autore,
    v.valore as valore_primo_rilascio, n.valore as valore_secondo_rilascio,
    n.valore - v.valore as differenza,
    case when v.valore is null then 'solo secondo rilascio'
         when n.valore is null then 'solo primo rilascio'
         when n.valore = v.valore then 'invariato'
         else 'rivisto' end as presenza
  from (select * from vecchio where anno = 2024 and valore is not null) v
  full join (select * from nuovo where anno = 2024) n
    on v.gruppo = n.gruppo and v.misura = n.misura and v.provincia = n.provincia and v.reato = n.reato
   and coalesce(v.fascia_eta,'') = coalesce(n.fascia_eta,'') and coalesce(v.sesso_autore,'') = coalesce(n.sesso_autore,'')
  order by abs(n.valore - v.valore) desc nulls last, gruppo, misura, provincia, reato, fascia_eta nulls first, sesso_autore nulls first
) to '$processed/revisioni_2024.csv' (header, delimiter ',');

-- Omicidi nazionali: stessa logica, 2019-2023 dal primo rilascio, 2024-2025 dal secondo
create table omicidi_vecchio as
with o as (
  select row_number() over () as riga, * from leggi('$csv/omicidi_dcpc.csv',
    ['etichetta','v2019','v2020','v2021','v2022','v2023','v2024'])
  where etichetta is not null
)
select riga, trim(etichetta) as etichetta_originale,
  case when riga in (1, 2) then 'tutti gli omicidi'
       when riga in (3, 4) then 'ambito familiare o affettivo'
       else 'partner o ex partner' end as ambito,
  case when riga % 2 = 0 then 'femminili' else 'tutte' end as vittime,
  (select anno from anni where anni.col = colonna) as anno,
  valore::int as valore
from o
unpivot (valore for colonna in (v2019, v2020, v2021, v2022, v2023, v2024));

copy (
  select ambito, vittime, etichetta_originale, anno, valore, 2026 as rilascio
  from read_csv('$aggregati/omicidi_dcpc_2024_2025.csv')
  union all by name
  select ambito, vittime, etichetta_originale, anno, valore, 2025 as rilascio
  from omicidi_vecchio where anno < 2024
  order by anno, ambito, vittime
) to '$processed/omicidi_dcpc_2019_2025.csv' (header, delimiter ',');
"

"$cartella/scripts/2026/verifica_identificativi.sh" "$processed"
