# chezmoi-doc

AI Knowledge Base for [chezmoi](https://www.chezmoi.io), the dotfile manager.

## Contents

- `src/` — Markdown source files mirrored from `twpayne/chezmoi` (`assets/chezmoi.io/docs/`)
- `cards/` — Knowledge Cards (YAML front-matter + Markdown), organized by category:
  `commands`, `concepts`, `configuration`, `encryption`, `externals`, `installation`, `password-managers`, `recipes`, `scripts`, `templates`
- `sync-docs.sh` — script to pull the latest docs from upstream

## Usage

Cards and source docs are loaded as context by the `chezmoi` Claude Code skill. See `CLAUDE.md` for the topic-to-file lookup table.

To refresh source docs from upstream:

```sh
./sync-docs.sh
```
