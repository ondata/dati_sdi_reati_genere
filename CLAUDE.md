<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

- usa duckdb -json -c con funzione st_read per leggere i file xlsx e i file geografici
- prima di prendere scelte su tabelle dati fai con duckdb query describe e summarize
- prima di prendere scelte su tabelle dati fai con duckdb un select limit 5 random
- Usa una oneline python pandas per leggere elenco nomi sheet di un xls e un xlsx
