#!/usr/bin/env bash
# Pipeline del file aggregato "Dati esitati 2024-2025" (aggregati.sh).
# Rilascio FOIA 2026 (riscontro del 15/05/2026, prot. MI-123-U-C-3-2-2026-88).
# 1. qsv: esporta in CSV gli 11 fogli, saltando le righe di titolo
# 2. duckdb: da tabelle pensate per la lettura a schermo a due CSV in formato lungo
#
# Dataset distinto da quello dei semestri (data/output/2026/microdati_2025/2025.csv): conteggi
# 2024-2025 per provincia, non righe per coppia vittima-autore. Non vanno uniti.

set -euo pipefail

cartella="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
raw="$cartella/data/rawdata/2026"
csv="$cartella/data/processing/2026/aggregati"
processed="$cartella/data/output/2026/aggregati_2024_2025"
legende="$cartella/data/output/2026/legende"

xlsx="Dati esitati 2024-2025 (MI-123-U-C-3-2-2026-88_4).xlsx"

mkdir -p "$csv" "$processed"

# 1. Export CSV grezzo
# qsv con --header-row scarta le righe di titolo e la riga di intestazione:
# i nomi delle colonne sono rimessi nel passo 2, perché in due fogli
# l'intestazione sta su due righe.

esporta() { # foglio, riga di intestazione, file
  qsv excel --sheet "$1" --header-row "$2" -q -o "$csv/$3.csv" "$raw/$xlsx"
}

esporta "Omicidi DCPC"              2 omicidi_dcpc
esporta "Delitti - Commessi"        4 delitti_commessi
esporta "Delitti - Vittime"         4 delitti_vittime
esporta "Delitti - Segnalazioni"    5 delitti_segnalazioni
esporta "Reati spia - Commessi"     4 reati_spia_commessi
esporta "Reati spia - Vittime"      4 reati_spia_vittime
esporta "Reati spia - Segnalazioni" 4 reati_spia_segnalazioni
esporta "Codice Rosso - Commessi"   4 codice_rosso_commessi
esporta "Codice Rosso - Vittime"    4 codice_rosso_vittime
esporta "Codice Rosso - Segnalazioni" 4 codice_rosso_segnalazioni

# 2. Formato lungo
# - una riga per combinazione di gruppo, misura, provincia, reato, fascia di
#   età, sesso del presunto autore e anno
# - num_ordine è il numero di catalogo del delitto, presente solo nei Delitti
# - sesso_autore è valorizzato solo nelle segnalazioni
# - i fogli "Vittime" e "Segnalazioni" riguardano vittime di sesso femminile
#   (così dice il titolo del foglio); per i "Commessi" il titolo non lo dice
# - perimetro_confrontabile: falso per le quattro province sarde, che nei dati
#   seguono la suddivisione precedente al 2006 (Sud Sardegna e Olbia-Tempio non
#   esistono e il loro territorio è dentro Cagliari, Nuoro, Oristano, Sassari)
# - cod_provincia_istat e provincia_istat dall'elenco ISTAT delle province/UTS
#   al 31/12/2025 (SITUAS report 64, scaricato con opensituas in
#   data/output/2026/legende/province_istat.csv); i nomi scritti diversamente nel
#   file del Ministero sono ricondotti con data/output/2026/legende/province_alias.csv
# - codice_provincia_storico, codice_regione, regione, ripartizione_geografica
#   dalla stessa tabella, con i nomi di colonna del rilascio 2019-2024

duckdb -c "
create macro leggi(file, nomi) as table
  select * from read_csv(file, header = false, all_varchar = true, names = nomi);

create table province as select trim(den_uts) as den_uts, trim(cod_uts) as cod_uts,
    trim(cod_prov_storico) as cod_prov_storico, trim(cod_reg) as cod_reg,
    trim(den_reg) as den_reg, trim(den_rip) as den_rip
  from read_csv('$legende/province_istat.csv', all_varchar = true);
create table alias_province as select trim(provincia_file) as provincia_file, trim(den_uts_istat) as den_uts
  from read_csv('$legende/province_alias.csv', all_varchar = true);

create table lungo as
with commessi as (
  select 'Delitti' as gruppo, provincia, num_ordine, reato, v2024, v2025
  from leggi('$csv/delitti_commessi.csv', ['provincia','num_ordine','reato','v2024','v2025'])
  union all by name
  select 'Reati spia' as gruppo, provincia, null as num_ordine, reato, v2024, v2025
  from leggi('$csv/reati_spia_commessi.csv', ['provincia','reato','v2024','v2025'])
  union all by name
  select 'Codice Rosso' as gruppo, provincia, null as num_ordine, reato, v2024, v2025
  from leggi('$csv/codice_rosso_commessi.csv', ['provincia','reato','v2024','v2025'])
),
vittime as (
  select 'Delitti' as gruppo, provincia, num_ordine, reato, fascia_eta, v2024, v2025
  from leggi('$csv/delitti_vittime.csv', ['provincia','num_ordine','reato','fascia_eta','v2024','v2025'])
  union all by name
  select 'Reati spia' as gruppo, provincia, null as num_ordine, reato, fascia_eta, v2024, v2025
  from leggi('$csv/reati_spia_vittime.csv', ['provincia','reato','fascia_eta','v2024','v2025'])
  union all by name
  select 'Codice Rosso' as gruppo, provincia, null as num_ordine, reato, fascia_eta, v2024, v2025
  from leggi('$csv/codice_rosso_vittime.csv', ['provincia','reato','fascia_eta','v2024','v2025'])
),
segnalazioni as (
  -- nei Delitti il sesso del presunto autore è nelle colonne, non in una riga
  select 'Delitti' as gruppo, provincia, num_ordine, reato, fascia_eta, sesso_autore,
    case sesso_autore when 'FEMMINILE' then f2024 else m2024 end as v2024,
    case sesso_autore when 'FEMMINILE' then f2025 else m2025 end as v2025
  from leggi('$csv/delitti_segnalazioni.csv', ['provincia','num_ordine','reato','fascia_eta','f2024','m2024','f2025','m2025'])
  cross join (select unnest(['FEMMINILE','MASCHILE']) as sesso_autore)
  union all by name
  select 'Reati spia' as gruppo, provincia, null as num_ordine, reato, fascia_eta, sesso_autore, v2024, v2025
  from leggi('$csv/reati_spia_segnalazioni.csv', ['provincia','reato','fascia_eta','sesso_autore','v2024','v2025'])
  union all by name
  select 'Codice Rosso' as gruppo, provincia, null as num_ordine, reato, fascia_eta, sesso_autore, v2024, v2025
  from leggi('$csv/codice_rosso_segnalazioni.csv', ['provincia','reato','fascia_eta','sesso_autore','v2024','v2025'])
),
tutto as (
  select gruppo, 'reati commessi' as misura, provincia, num_ordine, reato, null as fascia_eta, null as sesso_autore, v2024, v2025 from commessi
  union all by name
  select gruppo, 'vittime' as misura, provincia, num_ordine, reato, fascia_eta, null as sesso_autore, v2024, v2025 from vittime
  union all by name
  select gruppo, 'segnalazioni' as misura, provincia, num_ordine, reato, fascia_eta, sesso_autore, v2024, v2025 from segnalazioni
)
select gruppo, misura, trim(provincia) as provincia, num_ordine::int as num_ordine,
  trim(reato) as reato, trim(fascia_eta) as fascia_eta, trim(sesso_autore) as sesso_autore,
  anno::int as anno, nullif(trim(valore), '')::int as valore
from tutto
unpivot (valore for anno in (v2024 as '2024', v2025 as '2025'));

-- le righe senza valore sono celle vuote del foglio: si tolgono
-- ogni provincia deve trovare il suo codice: se ne manca una la pipeline si ferma
create table verifica_province as
select case when count(*) > 0
  then error('province senza codice ISTAT: ' || string_agg(distinct provincia, ', '))
end
from lungo l
anti join alias_province a on l.provincia = a.provincia_file
anti join province p on upper(strip_accents(p.den_uts)) = upper(strip_accents(l.provincia))
where l.provincia <> 'NON LOCALIZZATA';

copy (
  select
    l.gruppo, l.misura, l.provincia,
    p.cod_uts as cod_provincia_istat,
    p.den_uts as provincia_istat,
    p.cod_prov_storico as codice_provincia_storico,
    p.cod_reg as codice_regione,
    p.den_reg as regione,
    p.den_rip as ripartizione_geografica,
    case when l.provincia = 'NON LOCALIZZATA' then null
         else l.provincia not in ('CAGLIARI', 'NUORO', 'ORISTANO', 'SASSARI') end as perimetro_confrontabile,
    l.num_ordine, l.reato, l.fascia_eta, l.sesso_autore, l.anno, l.valore
  from lungo l
  left join alias_province a on l.provincia = a.provincia_file
  left join province p
    on upper(strip_accents(p.den_uts)) = upper(strip_accents(coalesce(a.den_uts, l.provincia)))
  where l.valore is not null
  order by l.gruppo, l.misura, l.provincia, l.reato, l.fascia_eta, l.sesso_autore, l.anno
) to '$processed/aggregati_2024_2025.csv' (header, delimiter ',');

-- Omicidi: foglio nazionale, righe annidate con '...di cui'
copy (
  with o as (
    select row_number() over () as riga, * from leggi('$csv/omicidi_dcpc.csv', ['etichetta','v2024','v2025'])
    where etichetta is not null
  ),
  etichettato as (
    select riga, trim(etichetta) as etichetta_originale,
      case when riga in (1, 2) then 'tutti gli omicidi'
           when riga in (3, 4) then 'ambito familiare o affettivo'
           else 'partner o ex partner' end as ambito,
      case when riga % 2 = 0 then 'femminili' else 'tutte' end as vittime,
      v2024, v2025
    from o
  )
  select ambito, vittime, etichetta_originale, anno::int as anno, valore::int as valore
  from etichettato
  unpivot (valore for anno in (v2024 as '2024', v2025 as '2025'))
  order by riga, anno
) to '$processed/omicidi_dcpc_2024_2025.csv' (header, delimiter ',');
"

"$cartella/scripts/2026/verifica_identificativi.sh" "$processed"
