-------------------------------------QUERY UTILIZZATA PER IL CARICAMENTO SU IRCAM 
--- DUBBI SU SOGGETTO autore oppure colp. da provv. 
---dubbi su selez. solo indicatore violenza genere oppure tutti i delitti oppure solo i casi in cui esoste la relazione
---dubbi su tentato e/o tentato/consumato
---dubbi sui luoghi e sui minori
select
  --b.c_uff_segn, b.n_comu, a.t_rea_eve, d.c_per_fis, m.c_per_fis, q2.c_per_fis, 
  --b.prot_sdi,
  --IN_CRIM_ODIO as indicatore_crimine_odio, 
  --a.IN_VIOL_GEN as indicatore_violenza_di_genere, 
  --IN_REATO_WEB as indicatore_reato_con_mezzi_informatici, 
  --IN_PRESENZA_MINORI as indicatore_presenza_minori, 
  --IN_VITT_DISABILE_FATTO as indicatore_presenza_disabile,
  --a.T_NORMA, a.N_LEGGE, a.aa_legge as anno_lgge, a.art, a.art_bt as art_bis, a.comma, a.COMMA_BT as comma_bis, a.PART_LET, 
  --case when b.flg_rea_eve = 'T' then 'TENTATO'
  --     when b.flg_rea_eve = 'C' then 'CONSUMATO'
  --       else '?' end as REATO, -----aggiunto il 11/11/2024 perchè ci sono i tentati omicidi
  --a.des_rea_eve,
  ------parte da qui il tracciato richiesto
  d.c_per_fis as id_vittima,
  case
    when a.t_rea_eve in ('575', 'P576A', 'R577A', 'S577B') then 'A'
    when a.t_rea_eve in ('581') then 'B'
    when a.t_rea_eve in ('582', '583', '585') then 'C'
    when a.t_rea_eve in (
      '609B',
      '609S',
      '609H',
      'P609B',
      'P609H',
      'P609S',
      'P609E'
    ) then 'D'
    when a.t_rea_eve in ('609F', '609D', 'P609D', 'P609F') then 'E'
    when a.t_rea_eve in ('572') then 'F'
    when a.t_rea_eve in ('612B1', '612B2', '612B3', '612B4') then 'G'
    when a.t_rea_eve in ('P612T', 'G612Q') then 'H'
    when a.t_rea_eve in ('P387B') then 'I'
    when a.t_rea_eve in ('P558B') then 'L'
    when a.t_rea_eve in ('P583B') then 'M'
    when a.t_rea_eve in ('P583Q') then 'N'
    when a.t_rea_eve in ('P593C') then 'O'
    when (
      a.T_REA_EVE IN (
        'P605A',
        'P605B',
        'P605C',
        'P605D',
        'P605E',
        'P605F',
        'P605G',
        'P605H'
      )
    ) then 'P'
    when a.t_rea_eve in ('610') then 'Q'
    when a.t_rea_eve in ('614') then 'R'
    when a.t_rea_eve in ('570') then 'S'
    when a.t_rea_eve in ('P570B') then 'S'
    when a.t_rea_eve in ('600A') then 'T'
    when a.t_rea_eve in ('591') then 'U'
    when a.t_rea_eve in ('635', 'S635B', 'S635A') then 'V'
    when a.t_rea_eve in ('629') then 'Z'
    when a.t_rea_eve in ('612') then 'AA'
    when a.t_rea_eve in ('643') then 'CC'
    when (
      a.T_REA_EVE IN ('601A ', '601A2', '601BB', '601CC')
    ) then 'DD'
    when a.t_rea_eve = 'A5901' then 'BB'
  end as reati,
  coalesce(b.d_tfat_da, b.d_ini_val_tfat) as data_accadimento,
  case ---dati ruolo autore
    when m.genere = 'M' then 1
    when m.genere = 'F' then 2
    else '0'
  end as sesso_autore,
  TIMESTAMPDIFF(
    256,
    TIMESTAMP(coalesce(b.D_TFAT_DA, B.D_INI_VAL_TFAT)) - TIMESTAMP(m.d_nas)
  ) AS ETA_autore,
  case
    when substr(digits(n.c_luo), 1, 2) in ('03', '04') then 'ITALIA'
    else n.des_luo
  end as nazione_nascita_autore,
  --case --dati ruolo sogg colp. da provv.
  --      when q3.sex = 'M' then 1 
  --      when q3.sex = 'F' then 2 
  --else '0' end as sex_colp_provv, 
  --TIMESTAMPDIFF(256, TIMESTAMP(coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT)) -  TIMESTAMP(q2.d_nas)) AS ETA_colp_provv, 
  --case when substr(digits(q2.c_luo_nas),1,2) in ('03', '04') then 'ITALIA' else q2.des_luo_nas end as nazione_nascita_colp_provv,
  case ----dati ruolo vittima
    when e.sex = 'M' then 1
    when e.sex = 'F' then 2
    else '0'
  end as sex_vittima,
  TIMESTAMPDIFF(
    256,
    TIMESTAMP(coalesce(b.D_TFAT_DA, B.D_INI_VAL_TFAT)) - TIMESTAMP(d.d_nas)
  ) AS ETA_vittima,
  case
    when substr(digits(d.c_luo_nas), 1, 2) in ('03', '04') then 'ITALIA'
    else d.des_luo_nas
  end as nazione_nascita_vittima,
  h.DES_RELAZIONE_VITT_AUT as relazione_autore_vittima, --h.DES_REL_VITT_AUT,
  --B.IN_PRESENZA_MINORI as PRESENZA_MINORI_fatto, 
  --g.PRESENZA_FIGLI AS PRESENZA_FIGLI_DENUNCIATO,
  --K.IN_PRES_FIGLI_VITT as presenza_figli_vittima,
  case
    when (
      K.IN_PRES_FIGLI_VITT = 'S'
      and b.in_presenza_minori = 'S'
      or (
        g.PRESENZA_FIGLI = 'S'
        and b.in_presenza_minori = 'S'
      )
    ) then 2
    when (
      K.IN_PRES_FIGLI_VITT = 'N'
      and g.PRESENZA_FIGLI = 'N'
    ) then 1
    else 0
  end as esistenza_FIGLI_minori, ---esistenza di figli minori
  case
    when (
      K.IN_PRES_FIGLI_VITT = 'S'
      and b.in_presenza_minori = 'S'
      or (
        g.PRESENZA_FIGLI = 'S'
        and b.in_presenza_minori = 'S'
      )
    ) then 2
    when (
      K.IN_PRES_FIGLI_VITT = 'N'
      and g.PRESENZA_FIGLI = 'N'
    ) then 1
    else 0
  end as presenza_FIGLI_minori, ---PRESENZA DI FIGLI MINORI in casa
  case
    when b2.des_luo_spec = 'ABITAZIONE' then 1
    when b2.des_luo_spec in ('NON PREVISTO/ALTRO', 'NON PREVISTO') then 0
    when b2.des_luo_spec in (
      'ABITAZIONE',
      'ABITAZIONE ISOLATA',
      'ALBERGO/BAR/RISTORANTE',
      'AMBULATORIO',
      'ATTIVITA'' PRIVATA NON PRECISATA',
      'ESERCIZIO COMMERCIALE',
      'FARMACIA',
      'INFRASTRUTTURA MILITARE',
      'ISTITUTO DI ISTRUZIONE',
      'ISTITUTO O CASA DI CURA',
      'LABORATORIO',
      'LOCALE/ESERCIZIO PUBBLICO',
      'LUOGO DI CULTO',
      'LUOGO RECINTATO',
      'MAGAZZINO O AREA DI DEPOSITO',
      'MUSEO',
      'OSPEDALE',
      'PALESTRA',
      'PROPRIETA'' PRIVATA',
      'STUDIO MEDICO',
      'STUDIO PRIVATO',
      'UFFICIO PUBBLICO'
    ) then 6
    when b2.des_luo_spec in (
      'APERTA CAMPAGNA/ZONA BOSCHIVA',
      'AREA ARCHEOLOGICA',
      'AREA DI SERVIZIO',
      'PUBBLICA VIA'
    ) then 7
    else 0
  end as luogo_del_fatto,
  case
    when i.DES_ARMA_UTILIZZATA = '' then 1
    when i.DES_ARMA_UTILIZZATA = 'ARMA DA TAGLIO/STRUMENTO ATTO AD OFFENDERE' then 3
    when i.DES_ARMA_UTILIZZATA = 'NO' then 1
    when i.DES_ARMA_UTILIZZATA is null then 1
    else 0
  end as tipologia_arma,
  case
    when p.t_inf_pol in ('AMMOM', 'AMMON', 'AMMOQ', 'AMMOS') then p.d_st_inf
  end as AMMONIMENTI,
  case
    when p.T_INF_POL IN (
      'ASCOL',
      'ASLAV',
      'DIOST',
      'DIRIT',
      'DISOS',
      'LIVIG',
      'MENTE',
      'RIFGI',
      'RIMAN',
      'RIREM'
    ) then p.d_st_inf
  end as MISURE_SICUREZZA,
  case
    when p.t_rea = 'P387B'
    and p.t_inf_pol = 'POLIN' then p.d_st_inf
  end as VIOLAZIONI
  --D.COGN as cogn_vittima, D.NOME as nome_Vittima, D.D_NAS_VIS as d_nas_vittima, D.DES_LUO_NAS as luogo_nascita_vittima, D.SGL_PRV_NAS as prv_nascita_vittima , D.C_FISC as c_fisc_vittima
  --, A.DES_REA_EVE, a.AA_LEGGE, a.N_LEGGE, a.ART, a.ART_BT, a.COMMA, a.COMMA_BT, a.PART_LET 
  --, coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT) as data_reato, b1.DES_OBIET, b2.DES_LUO_SPEC
  --, e.SEX as sex_vittima, e.DES_LUO_CITT as cittadinanza_vittima, TIMESTAMPDIFF(256, TIMESTAMP(coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT)) -  TIMESTAMP(d.d_nas)) AS ETA_vittima
  --, m.COGN as cogn_AUTORE, m.noME as nome_AUTORE, m.D_NAS as d_nas_AUTORE, n.DES_LUO as luogo_nascita_AUTORE, n.SGL_PRV as prv_nascita_AUTORE  
  --, m.genere as sex_autore,  m.eta AS ETA_AUTORE
  --, B.IN_PRESENZA_MINORI 
  --, K.IN_PRES_FIGLI_VITT
  --, g.PRESENZA_FIGLI AS PRESENZA_FIGLI_DENUNCIATO
  --, h.DES_REL_VITT_AUT 
  --, i.DES_ARMA_UTILIZZATA 
  --, P1.DES_INF_POL, P2.DES_ST_INF, P.N_INF, P.D_ST_INF, P.C_UFF_SEGN || ' - ' || P3S.DES_UFF_SEGN AS UFFICIO_SEGNALANTE, P.C_UFF_SEGN_PROVV || ' - ' || P3E.DES_UFF_SEGN AS UFFICIO_EMITTENTE
  --, b.n_comu, b.c_uff_segn
FROM
  sdi.TPSM01_REATOEVENTO a
  INNER JOIN SDI.TFP013_TFAT_FATTO B ON a.IN_VIOL_GEN = 'S' ----reato violenza genere in reatoevento
  and b.IN_VIOL_GEN = 'S' ----indicatore violenza genere fatto
  and b.flg_rea_eve = 'C' ------reato consumato
  AND A.D_REG_CAN IS NULL
  AND B.T_REA_EVE = A.T_REA_EVE
  AND B.D_REG_CAN IS NULL
  --and date(b.n_comu) > '31.12.2023'
  and coalesce(b.d_tfat_da, b.d_ini_val_tfat) between '01.07.2025' and '31.12.2025'
  inner join sdi.TFPM02_OBIETTIVO b1 on b1.C_OBIET = b.C_OBIET
  and b1.D_REG_CAN is null
  inner join sdi.TFPM02_LUO_SPEC b2 on b2.C_LUO_SPEC = b.C_LUO_SPEC
  and b2.D_REG_CAN is null
  INNER JOIN SDI.TSO003_SOGG_COMU C ON C.N_COMU = B.N_COMU
  AND C.C_UFF_SEGN = B.C_UFF_SEGN
  AND C.FLG_SOGG = 'F'
  AND C.DES_RUO_SOGG IN ('SCOMPARSO', 'VITTIMA') ---perchè nel sequestro c è solo il denunciato
  AND C.D_REG_CAN IS NULL
  INNER JOIN SDI.TSO001_PER_FIS D ON D.C_PER_FIS = C.C_SOGG
  AND D.D_REG_CAN IS NULL
  left outer join sdi.TSO019_PROF_COMU e on e.N_COMU = B.N_COMU
  AND e.C_UFF_SEGN = B.C_UFF_SEGN
  AND e.C_PER_FIS = c.C_SOGG
  AND e.D_REG_CAN IS NULL
  left outer join sdi.TFP027_PROFILO_VIOLENZA_GENERE K on K.N_COMU = B.N_COMU
  AND K.C_UFF_SEGN = B.C_UFF_SEGN
  AND K.C_PER_FIS = c.C_SOGG
  AND K.D_REG_CAN IS NULL
  left outer join sdi.TFP026_RELAZIONE_AUTORE_VITTIMA g on g.N_COMU = B.N_COMU
  AND g.C_UFF_SEGN = B.C_UFF_SEGN
  AND g.C_SOGG_VITT = c.C_SOGG
  AND g.D_REG_CAN IS NULL
  left outer join sdi.TFP025_PRESUNTO_AUTORE m on m.N_COMU = B.N_COMU
  AND m.C_UFF_SEGN = B.C_UFF_SEGN
  AND m.ID_DENUNCIATO = g.ID_DENUNCIATO
  AND m.D_REG_CAN IS NULL
  left outer join sdi.TLG001_LUOGO n on n.C_LUO = m.C_LUO_NAS
  and n.d_reg_can is null
  left outer join sdi.RELAZIONE_VITT_AUT h on h.C_RELAZIONE_VITT_AUT = g.C_RELAZIONE_VITT_AUT
  and h.TS_CANCELLAZIONE is null
  --left outer join sdi.TPSM03_RELAZIONE_VITT_AUT h on
  --    h.C_REL_VITT_AUT = g.C_RELAZIONE_VITT_AUT
  --and h.d_reg_can is null    
  left outer join sdi.TFPM02_TIPO_ARMA_UTILIZZATA i on i.T_ARMA_UTILIZZATA = g.T_ARMA_UTILIZZATA
  and i.D_REG_CAN is null
  LEFT OUTER JOIN SDI.TPS002_INFO_POL P ON P.N_COMU_FAT = B.N_COMU
  AND P.C_UFF_SEGN_FAT = B.C_UFF_SEGN
  AND P.D_REG_CAN IS NULL
  and (
    p.T_INF_POL IN (
      'ASCOL',
      'ASLAV',
      'DIOST',
      'DIRIT',
      'DISOS',
      'LIVIG',
      'MENTE',
      'RIFGI',
      'RIMAN',
      'RIREM'
    )
    and p.t_st_inf = 'SEGN'
    or (
      p.t_inf_pol in ('AMMOM', 'AMMON', 'AMMOQ', 'AMMOS')
      and p.t_st_inf = 'SEGN'
    )
    or (
      p.t_rea = 'P387B'
      and p.t_inf_pol = 'POLIN'
      and p.t_st_inf = 'SEGN'
    )
  )
  LEFT OUTER JOIN SDI.TPSM01_TIPOINFOPOL P1 ON P1.T_INF_POL = P.T_INF_POL
  AND P1.DETT_INF_POL = P.DETT_INF_POL
  AND P1.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TPSM01_TIPO_STINFO P2 ON P2.T_ST_INF = P.T_ST_INF
  AND P2.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TSO022_UFF_SEGN P3S ON P3S.C_UFF_SEGN = P.C_UFF_SEGN
  AND P3S.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TSO022_UFF_SEGN P3E ON P3E.C_UFF_SEGN = P.C_UFF_SEGN_PROVV
  AND P3E.D_REG_CAN IS NULL
  left join sdi.tso003_sogg_comu q on q.c_uff_segn = p.c_uff_segn
  and q.n_comu = p.n_comu
  and q.d_Reg_can is null
  and q.des_ruo_sogg = 'COLP. DA PROVV.'
  left join sdi.tso001_per_fis q2 on q.c_sogg = q2.c_per_fis
  and q2.d_reg_can is null
  left join sdi.tso019_prof_comu q3 on q.c_uff_segn = q3.c_uff_segn
  and q.n_comu = q3.n_comu
  and q.c_sogg = q3.c_per_fis
  and q3.d_reg_can is null
union all
-------------------------------------QUERY UTILIZZATA PER IL CARICAMENTO SU IRCAM 
--- DUBBI SU SOGGETTO autore oppure colp. da provv. 
---dubbi su selez. solo indicatore violenza genere oppure tutti i delitti oppure solo i casi in cui esoste la relazione
---dubbi su tentato e/o tentato/consumato
---dubbi sui luoghi e sui minori
select
  --b.c_uff_segn, b.n_comu, a.t_rea_eve, d.c_per_fis, m.c_per_fis, q2.c_per_fis, 
  --b.prot_sdi,
  --IN_CRIM_ODIO as indicatore_crimine_odio, 
  --a.IN_VIOL_GEN as indicatore_violenza_di_genere, 
  --IN_REATO_WEB as indicatore_reato_con_mezzi_informatici, 
  --IN_PRESENZA_MINORI as indicatore_presenza_minori, 
  --IN_VITT_DISABILE_FATTO as indicatore_presenza_disabile,
  --a.T_NORMA, a.N_LEGGE, a.aa_legge as anno_lgge, a.art, a.art_bt as art_bis, a.comma, a.COMMA_BT as comma_bis, a.PART_LET, 
  --case when b.flg_rea_eve = 'T' then 'TENTATO'
  --     when b.flg_rea_eve = 'C' then 'CONSUMATO'
  --       else '?' end as REATO, -----aggiunto il 11/11/2024 perchè ci sono i tentati omicidi
  --a.des_rea_eve,
  ------parte da qui il tracciato richiesto
  d.c_per_fis as id_vittima,
  case
    when a.t_rea_eve in ('575', 'P576A', 'R577A', 'S577B') then 'A'
    when a.t_rea_eve in ('581') then 'B'
    when a.t_rea_eve in ('582', '583', '585') then 'C'
    when a.t_rea_eve in (
      '609B',
      '609S',
      '609H',
      'P609B',
      'P609H',
      'P609S',
      'P609E'
    ) then 'D'
    when a.t_rea_eve in ('609F', '609D', 'P609D', 'P609F') then 'E'
    when a.t_rea_eve in ('572') then 'F'
    when a.t_rea_eve in ('612B1', '612B2', '612B3', '612B4') then 'G'
    when a.t_rea_eve in ('P612T', 'G612Q') then 'H'
    when a.t_rea_eve in ('P387B') then 'I'
    when a.t_rea_eve in ('P558B') then 'L'
    when a.t_rea_eve in ('P583B') then 'M'
    when a.t_rea_eve in ('P583Q') then 'N'
    when a.t_rea_eve in ('P593C') then 'O'
    when (
      a.T_REA_EVE IN (
        'P605A',
        'P605B',
        'P605C',
        'P605D',
        'P605E',
        'P605F',
        'P605G',
        'P605H'
      )
    ) then 'P'
    when a.t_rea_eve in ('610') then 'Q'
    when a.t_rea_eve in ('614') then 'R'
    when a.t_rea_eve in ('570') then 'S'
    when a.t_rea_eve in ('P570B') then 'S'
    when a.t_rea_eve in ('600A') then 'T'
    when a.t_rea_eve in ('591') then 'U'
    when a.t_rea_eve in ('635', 'S635B', 'S635A') then 'V'
    when a.t_rea_eve in ('629') then 'Z'
    when a.t_rea_eve in ('612') then 'AA'
    when a.t_rea_eve in ('643') then 'CC'
    when (
      a.T_REA_EVE IN ('601A ', '601A2', '601BB', '601CC')
    ) then 'DD'
    when a.t_rea_eve = 'A5901' then 'BB'
  end as reati,
  coalesce(b.d_tfat_da, b.d_ini_val_tfat) as data_accadimento,
  case ---dati ruolo autore
    when m.genere = 'M' then 1
    when m.genere = 'F' then 2
    else '0'
  end as sesso_autore,
  TIMESTAMPDIFF(
    256,
    TIMESTAMP(coalesce(b.D_TFAT_DA, B.D_INI_VAL_TFAT)) - TIMESTAMP(m.d_nas)
  ) AS ETA_autore,
  case
    when substr(digits(n.c_luo), 1, 2) in ('03', '04') then 'ITALIA'
    else n.des_luo
  end as nazione_nascita_autore,
  --case --dati ruolo sogg colp. da provv.
  --      when q3.sex = 'M' then 1 
  --      when q3.sex = 'F' then 2 
  --else '0' end as sex_colp_provv, 
  --TIMESTAMPDIFF(256, TIMESTAMP(coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT)) -  TIMESTAMP(q2.d_nas)) AS ETA_colp_provv, 
  --case when substr(digits(q2.c_luo_nas),1,2) in ('03', '04') then 'ITALIA' else q2.des_luo_nas end as nazione_nascita_colp_provv,
  case ----dati ruolo vittima
    when e.sex = 'M' then 1
    when e.sex = 'F' then 2
    else '0'
  end as sex_vittima,
  TIMESTAMPDIFF(
    256,
    TIMESTAMP(coalesce(b.D_TFAT_DA, B.D_INI_VAL_TFAT)) - TIMESTAMP(d.d_nas)
  ) AS ETA_vittima,
  case
    when substr(digits(d.c_luo_nas), 1, 2) in ('03', '04') then 'ITALIA'
    else d.des_luo_nas
  end as nazione_nascita_vittima,
  h.DES_RELAZIONE_VITT_AUT as relazione_autore_vittima, --h.DES_REL_VITT_AUT,
  --B.IN_PRESENZA_MINORI as PRESENZA_MINORI_fatto, 
  --g.PRESENZA_FIGLI AS PRESENZA_FIGLI_DENUNCIATO,
  --K.IN_PRES_FIGLI_VITT as presenza_figli_vittima,
  case
    when (
      K.IN_PRES_FIGLI_VITT = 'S'
      and b.in_presenza_minori = 'S'
      or (
        g.PRESENZA_FIGLI = 'S'
        and b.in_presenza_minori = 'S'
      )
    ) then 2
    when (
      K.IN_PRES_FIGLI_VITT = 'N'
      and g.PRESENZA_FIGLI = 'N'
    ) then 1
    else 0
  end as esistenza_FIGLI_minori, ---esistenza di figli minori
  case
    when (
      K.IN_PRES_FIGLI_VITT = 'S'
      and b.in_presenza_minori = 'S'
      or (
        g.PRESENZA_FIGLI = 'S'
        and b.in_presenza_minori = 'S'
      )
    ) then 2
    when (
      K.IN_PRES_FIGLI_VITT = 'N'
      and g.PRESENZA_FIGLI = 'N'
    ) then 1
    else 0
  end as presenza_FIGLI_minori, ---PRESENZA DI FIGLI MINORI in casa
  case
    when b2.des_luo_spec = 'ABITAZIONE' then 1
    when b2.des_luo_spec in ('NON PREVISTO/ALTRO', 'NON PREVISTO') then 0
    when b2.des_luo_spec in (
      'ABITAZIONE',
      'ABITAZIONE ISOLATA',
      'ALBERGO/BAR/RISTORANTE',
      'AMBULATORIO',
      'ATTIVITA'' PRIVATA NON PRECISATA',
      'ESERCIZIO COMMERCIALE',
      'FARMACIA',
      'INFRASTRUTTURA MILITARE',
      'ISTITUTO DI ISTRUZIONE',
      'ISTITUTO O CASA DI CURA',
      'LABORATORIO',
      'LOCALE/ESERCIZIO PUBBLICO',
      'LUOGO DI CULTO',
      'LUOGO RECINTATO',
      'MAGAZZINO O AREA DI DEPOSITO',
      'MUSEO',
      'OSPEDALE',
      'PALESTRA',
      'PROPRIETA'' PRIVATA',
      'STUDIO MEDICO',
      'STUDIO PRIVATO',
      'UFFICIO PUBBLICO'
    ) then 6
    when b2.des_luo_spec in (
      'APERTA CAMPAGNA/ZONA BOSCHIVA',
      'AREA ARCHEOLOGICA',
      'AREA DI SERVIZIO',
      'PUBBLICA VIA'
    ) then 7
    else 0
  end as luogo_del_fatto,
  case
    when i.DES_ARMA_UTILIZZATA = '' then 1
    when i.DES_ARMA_UTILIZZATA = 'ARMA DA TAGLIO/STRUMENTO ATTO AD OFFENDERE' then 3
    when i.DES_ARMA_UTILIZZATA = 'NO' then 1
    when i.DES_ARMA_UTILIZZATA is null then 1
    else 0
  end as tipologia_arma,
  case
    when p.t_inf_pol in ('AMMOM', 'AMMON', 'AMMOQ', 'AMMOS') then p.d_st_inf
  end as AMMONIMENTI,
  case
    when p.T_INF_POL IN (
      'ASCOL',
      'ASLAV',
      'DIOST',
      'DIRIT',
      'DISOS',
      'LIVIG',
      'MENTE',
      'RIFGI',
      'RIMAN',
      'RIREM'
    ) then p.d_st_inf
  end as MISURE_SICUREZZA,
  case
    when p.t_rea = 'P387B'
    and p.t_inf_pol = 'POLIN' then p.d_st_inf
  end as VIOLAZIONI
  --D.COGN as cogn_vittima, D.NOME as nome_Vittima, D.D_NAS_VIS as d_nas_vittima, D.DES_LUO_NAS as luogo_nascita_vittima, D.SGL_PRV_NAS as prv_nascita_vittima , D.C_FISC as c_fisc_vittima
  --, A.DES_REA_EVE, a.AA_LEGGE, a.N_LEGGE, a.ART, a.ART_BT, a.COMMA, a.COMMA_BT, a.PART_LET 
  --, coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT) as data_reato, b1.DES_OBIET, b2.DES_LUO_SPEC
  --, e.SEX as sex_vittima, e.DES_LUO_CITT as cittadinanza_vittima, TIMESTAMPDIFF(256, TIMESTAMP(coalesce(b.D_TFAT_DA,B.D_INI_VAL_TFAT)) -  TIMESTAMP(d.d_nas)) AS ETA_vittima
  --, m.COGN as cogn_AUTORE, m.noME as nome_AUTORE, m.D_NAS as d_nas_AUTORE, n.DES_LUO as luogo_nascita_AUTORE, n.SGL_PRV as prv_nascita_AUTORE  
  --, m.genere as sex_autore,  m.eta AS ETA_AUTORE
  --, B.IN_PRESENZA_MINORI 
  --, K.IN_PRES_FIGLI_VITT
  --, g.PRESENZA_FIGLI AS PRESENZA_FIGLI_DENUNCIATO
  --, h.DES_REL_VITT_AUT 
  --, i.DES_ARMA_UTILIZZATA 
  --, P1.DES_INF_POL, P2.DES_ST_INF, P.N_INF, P.D_ST_INF, P.C_UFF_SEGN || ' - ' || P3S.DES_UFF_SEGN AS UFFICIO_SEGNALANTE, P.C_UFF_SEGN_PROVV || ' - ' || P3E.DES_UFF_SEGN AS UFFICIO_EMITTENTE
  --, b.n_comu, b.c_uff_segn
FROM
  sdi.TPSM01_REATOEVENTO a
  INNER JOIN SDI.TFP013_TFAT_FATTO B ON a.IN_VIOL_GEN = 'S' ----reato violenza genere in reatoevento
  and b.IN_VIOL_GEN = 'S' ----indicatore violenza genere fatto
  and b.flg_rea_eve = 'T' ------reato tentato
  and a.t_rea_eve = '575'
  AND A.D_REG_CAN IS NULL
  AND B.T_REA_EVE = A.T_REA_EVE
  AND B.D_REG_CAN IS NULL
  --and date(b.n_comu) > '31.12.2023'
  and coalesce(b.d_tfat_da, b.d_ini_val_tfat) between '01.07.2025' and '31.12.2025'
  inner join sdi.TFPM02_OBIETTIVO b1 on b1.C_OBIET = b.C_OBIET
  and b1.D_REG_CAN is null
  inner join sdi.TFPM02_LUO_SPEC b2 on b2.C_LUO_SPEC = b.C_LUO_SPEC
  and b2.D_REG_CAN is null
  INNER JOIN SDI.TSO003_SOGG_COMU C ON C.N_COMU = B.N_COMU
  AND C.C_UFF_SEGN = B.C_UFF_SEGN
  AND C.FLG_SOGG = 'F'
  AND C.DES_RUO_SOGG IN ('SCOMPARSO', 'VITTIMA') ---perchè nel sequestro c è solo il denunciato
  AND C.D_REG_CAN IS NULL
  INNER JOIN SDI.TSO001_PER_FIS D ON D.C_PER_FIS = C.C_SOGG
  AND D.D_REG_CAN IS NULL
  left outer join sdi.TSO019_PROF_COMU e on e.N_COMU = B.N_COMU
  AND e.C_UFF_SEGN = B.C_UFF_SEGN
  AND e.C_PER_FIS = c.C_SOGG
  AND e.D_REG_CAN IS NULL
  left outer join sdi.TFP027_PROFILO_VIOLENZA_GENERE K on K.N_COMU = B.N_COMU
  AND K.C_UFF_SEGN = B.C_UFF_SEGN
  AND K.C_PER_FIS = c.C_SOGG
  AND K.D_REG_CAN IS NULL
  left outer join sdi.TFP026_RELAZIONE_AUTORE_VITTIMA g on g.N_COMU = B.N_COMU
  AND g.C_UFF_SEGN = B.C_UFF_SEGN
  AND g.C_SOGG_VITT = c.C_SOGG
  AND g.D_REG_CAN IS NULL
  left outer join sdi.TFP025_PRESUNTO_AUTORE m on m.N_COMU = B.N_COMU
  AND m.C_UFF_SEGN = B.C_UFF_SEGN
  AND m.ID_DENUNCIATO = g.ID_DENUNCIATO
  AND m.D_REG_CAN IS NULL
  left outer join sdi.TLG001_LUOGO n on n.C_LUO = m.C_LUO_NAS
  and n.d_reg_can is null
  left outer join sdi.RELAZIONE_VITT_AUT h on h.C_RELAZIONE_VITT_AUT = g.C_RELAZIONE_VITT_AUT
  and h.TS_CANCELLAZIONE is null
  --left outer join sdi.TPSM03_RELAZIONE_VITT_AUT h on
  --    h.C_REL_VITT_AUT = g.C_RELAZIONE_VITT_AUT
  --and h.d_reg_can is null    
  left outer join sdi.TFPM02_TIPO_ARMA_UTILIZZATA i on i.T_ARMA_UTILIZZATA = g.T_ARMA_UTILIZZATA
  and i.D_REG_CAN is null
  LEFT OUTER JOIN SDI.TPS002_INFO_POL P ON P.N_COMU_FAT = B.N_COMU
  AND P.C_UFF_SEGN_FAT = B.C_UFF_SEGN
  AND P.D_REG_CAN IS NULL
  and (
    p.T_INF_POL IN (
      'ASCOL',
      'ASLAV',
      'DIOST',
      'DIRIT',
      'DISOS',
      'LIVIG',
      'MENTE',
      'RIFGI',
      'RIMAN',
      'RIREM'
    )
    and p.t_st_inf = 'SEGN'
    or (
      p.t_inf_pol in ('AMMOM', 'AMMON', 'AMMOQ', 'AMMOS')
      and p.t_st_inf = 'SEGN'
    )
    or (
      p.t_rea = 'P387B'
      and p.t_inf_pol = 'POLIN'
      and p.t_st_inf = 'SEGN'
    )
  )
  LEFT OUTER JOIN SDI.TPSM01_TIPOINFOPOL P1 ON P1.T_INF_POL = P.T_INF_POL
  AND P1.DETT_INF_POL = P.DETT_INF_POL
  AND P1.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TPSM01_TIPO_STINFO P2 ON P2.T_ST_INF = P.T_ST_INF
  AND P2.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TSO022_UFF_SEGN P3S ON P3S.C_UFF_SEGN = P.C_UFF_SEGN
  AND P3S.D_REG_CAN IS NULL
  LEFT OUTER JOIN SDI.TSO022_UFF_SEGN P3E ON P3E.C_UFF_SEGN = P.C_UFF_SEGN_PROVV
  AND P3E.D_REG_CAN IS NULL
  left join sdi.tso003_sogg_comu q on q.c_uff_segn = p.c_uff_segn
  and q.n_comu = p.n_comu
  and q.d_Reg_can is null
  and q.des_ruo_sogg = 'COLP. DA PROVV.'
  left join sdi.tso001_per_fis q2 on q.c_sogg = q2.c_per_fis
  and q2.d_reg_can is null
  left join sdi.tso019_prof_comu q3 on q.c_uff_segn = q3.c_uff_segn
  and q.n_comu = q3.n_comu
  and q.c_sogg = q3.c_per_fis
  and q3.d_reg_can is null
with ur
