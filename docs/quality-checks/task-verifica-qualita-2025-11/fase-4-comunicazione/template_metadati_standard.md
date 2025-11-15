# Template Metadati Standard DCAT-AP_IT per Dati SDI Reati Genere

**Standard di riferimento**: DCAT-AP_IT v2.0  
**Versione template**: 1.0  
**Data**: 2025-11-15  

## Metadati Obbligatori (9/9)

### Identificativo Dataset
```json
{
  "dct:identifier": "MI-DPS-SDI-REATI-GENERE-2025",
  "dct:title": "Dati SDI Reati di Genere - Dipartimento Pubblica Sicurezza",
  "dct:description": "Dataset contenente i dati dettagliati dei reati di genere registrati nel Sistema Diagnosi Sociale (SDI) del Ministero dell'Interno. Include informazioni su vittime, autori, tipo di reato, circostanze e relazioni vittima-autore, conformemente alla Legge 53/2022 (Codice Rosso)."
}
```

### Descrizione Completa
```json
{
  "dct:description": {
    "it": "Dataset ufficiale del Dipartimento della Pubblica Sicurezza contenente i dati aggregati e dettagliati dei reati di genere registrati attraverso il Sistema Diagnosi Sociale (SDI). I dati coprono il periodo [ANNO_INIZIO]-[ANNO_FINE] e includono: maltrattamenti contro familiari e conviventi (art. 572 c.p.), violenza domestica (art. 583 quinquies c.p.), percosse e lesioni (art. 581/582 c.p.), atti persecutori (art. 612-bis c.p.), violenza sessuale (art. 609-bis c.p.), e altri reati correlati. Il dataset è strutturato per supportare analisi statistiche, monitoraggio delle politiche pubbliche di contrasto alla violenza di genere e ricerca accademica, nel rispetto della privacy delle vittime e delle normative sulla protezione dei dati personali (GDPR e D.Lgs. 196/2003).",
    "en": "Official dataset from the Department of Public Security containing detailed data on gender-based crimes recorded through the Social Diagnosis System (SDI). Data covers the period [START_YEAR]-[END_YEAR] and includes: domestic abuse (art. 572 c.p.), domestic violence (art. 583 quinquies c.p.), assault and battery (art. 581/582 c.p.), stalking (art. 612-bis c.p.), sexual violence (art. 609-bis c.p.), and related crimes. The dataset is structured to support statistical analysis, monitoring of public policies against gender-based violence, and academic research, respecting victim privacy and data protection regulations (GDPR and Italian Legislative Decree 196/2003)."
  }
}
```

### Editore/Pubblicatore
```json
{
  "dct:publisher": {
    "foaf:name": "Dipartimento della Pubblica Sicurezza - Ministero dell'Interno",
    "foaf:mbox": "protocollo@interno.it",
    "dct:type": "Public Administration"
  }
}
```

### Data di Pubblicazione e Aggiornamento
```json
{
  "dct:issued": "2025-10-15",
  "dct:modified": "2025-11-15",
  "dct:accrualPeriodicity": {
    "skos:prefLabel": {
      "it": "Annuale",
      "en": "Annual"
    }
  }
}
```

### Periodo Temporale di Riferimento
```json
{
  "dct:temporal": {
    "time:hasBeginning": "2019-01-01",
    "time:hasEnd": "2024-12-31",
    "dcat:startDate": "2019-01-01",
    "dcat:endDate": "2024-12-31"
  }
}
```

### Licenza
```json
{
  "dct:license": {
    "dct:type": "CC0-1.0",
    "rdfs:label": "Creative Commons Zero v1.0 Universal",
    "rdfs:comment": "Dati aperti riutilizzabili senza restrizioni"
  }
}
```

**Diritti di Accesso**
```json
{
  "dct:accessRights": {
    "dct:type": "Public",
    "rdfs:label": {
      "it": "Pubblico",
      "en": "Public"
    }
  }
}
```

**Frequenza di Aggiornamento**
```json
{
  "dct:accrualPeriodicity": {
    "skos:prefLabel": {
      "it": "Annuale",
      "en": "Annual"
    },
    "skos:notation": "http://publications.europa.eu/resource/authority/frequency/ANNUAL"
  }
}
```

### 9. Lingua
```json
{
  "dct:language": {
    "skos:prefLabel": {
      "it": "Italiano",
      "en": "Italian"
    },
    "skos:notation": "ita"
  }
}
```

## Metadati Raccomandati (Importanti)

### 10. Soggetto/Keywords
```json
{
  "dcat:keyword": [
    "reati di genere",
    "violenza domestica", 
    "codice rosso",
    "sistema diagnosi sociale",
    "maltrattamenti",
    "violenza sessuale",
    "atti persecutori",
    "dati statistici",
    "sicurezza pubblica",
    "politiche di genere"
  ]
}
```

### 11. Copertura Geografica
```json
{
  "dct:spatial": {
    "skos:prefLabel": {
      "it": "Italia",
      "en": "Italy"
    },
    "skos:notation": "IT"
  }
}
```

### 12. Metodologia di Raccolta
```json
{
  "dct:provenance": "Dati raccolti attraverso il Sistema Diagnosi Sociale (SDI) delle Forze di Polizia. I dati sono registrati dalle forze dell'ordine durante interventi relativi a reati di genere, seguendo le procedure operative standard del Dipartimento della Pubblica Sicurezza. La raccolta dati è conforme alle linee guida ISTAT per le statistiche sulla giustizia penale.",
  "dct:methodology": "Registrazione sistematica dei casi tramite moduli standardizzati SDI. Validazione interna a cura del Servizio Analisi Criminale del Dipartimento della Pubblica Sicurezza. Aggregazione e anonimizzazione dati secondo protocolli privacy GDPR."
}
```

### 13. Qualità Dati
```json
{
  "dqv:hasQualityAnnotation": {
    "oa:hasBody": "I dati sono sottoposti a controlli di qualità interni. Eventuali discrepanze rispetto ad altre fonti statistiche (es. ISTAT) sono dovute a diverse metodologie di raccolta e periodi di riferimento. Per segnalazioni di qualità dati: qualità@interno.it"
  }
}
```

### 14. Limitazioni e Note
```json
{
  "dct:relation": {
    "rdfs:comment": "I dati sono aggregati e anonimizzati per proteggere la privacy delle vittime. Non sono inclusi dati personali diretti. Alcuni record potrebbero presentare valori mancanti per campi geografici specifici (DES_OBIET) quando non identificabili. I dati relativi al periodo 2019-2020 sono parziali a causa dell'implementazione graduale del SDI."
  }
}
```

## Metadati Opzionali (Utili)

### 15. Contatto Tecnico
```json
{
  "dcat:contactPoint": {
    "vcard:fn": "Ufficio Statistica e Analisi",
    "vcard:hasEmail": "statistica@interno.it",
    "vcard:hasTelephone": "+39-06-4654xxxx"
  }
}
```

### 16. Formato Dati
```json
{
  "dcat:distribution": {
    "dct:format": {
      "skos:prefLabel": "CSV",
      "skos:notation": "text/csv"
    },
    "dcat:mediaType": "text/csv",
    "dcat:byteSize": "SIZE_IN_BYTES"
  }
}
```

### 17. Schema Dati
```json
{
  "dcat:dataset": {
    "dcat:distribution": {
      "dct:conformsTo": "https://github.com/dati-gov-it/dati-ckan-schema/blob/master/schemas/dataset.json",
      "adms:representationTechnique": "Tabular data"
    }
  }
}
```

## Checklist Validazione

- [ ] Tutti i 9 metadati obbligatori compilati
- [ ] Descrizione completa in italiano e inglese  
- [ ] Periodo temporale specificato con date precise
- [ ] Licenza CC0-1.0 o compatibile
- [ ] Contatti tecnici aggiornati
- [ ] Keywords pertinenti e standardizzate
- [ ] Note metodologiche e limitazioni chiare
- [ ] Formato dati conforme standard aperti

---

**Note implementative**:
1. Sostituire `[ANNO_INIZIO]`, `[ANNO_FINE]`, `SIZE_IN_BYTES` con valori reali
2. Aggiornare date di pubblicazione/modifica effettive
3. Verificare contatti email e telefonici aggiornati
4. Personalizzare keywords per specifico dataset
5. Includere riferimenti a documentazione metodologica disponibile