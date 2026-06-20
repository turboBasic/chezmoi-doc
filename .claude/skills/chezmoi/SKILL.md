---
name: chezmoi
description: Look up chezmoi documentation — commands, concepts, configuration, templates, scripts, encryption, password managers, externals, troubleshooting, recipes
allowed-tools: Read, Bash(grep *), Bash(find *), Bash(wc *)
---

You are a knowledge base lookup skill for **chezmoi** (twpayne/chezmoi), the dotfile manager that manages your dotfiles across multiple machines.

## Steps

1. Derive the repo root: this file lives at `<repo-root>/.claude/skills/chezmoi/SKILL.md`.
   Strip `/.claude/skills/chezmoi/SKILL.md` from the path this file was loaded from to get `<repo-root>`.

2. Based on the user's question, identify which category directory is relevant (see topic routing below).

3. List files in the relevant directory to find matching cards:
   `find <repo-root>/cards/<category>/ -name "*.md" | sort`

4. If the right card isn't obvious from the filename, grep for the relevant keyword:
   `grep -rln "<keyword>" <repo-root>/cards/`

5. Read the relevant card(s) from `<repo-root>/cards/<category>/`.

6. Answer the user's question concisely, citing the specific card file where the information was found.

## Topic routing

| Topic                                              | Directory                    |
| -------------------------------------------------- | ---------------------------- |
| CLI commands (add, apply, init, edit, diff, etc.)  | `cards/commands/`            |
| Architecture / source state / target state         | `cards/concepts/`            |
| Config file, hooks, editor, interpreters           | `cards/configuration/`       |
| Templates, variables, conditionals, functions      | `cards/templates/`           |
| Scripts (run_, run_once_, run_onchange_)           | `cards/scripts/`             |
| External files/archives (.chezmoiexternal)         | `cards/externals/`           |
| Encryption (age, gpg)                              | `cards/encryption/`          |
| Password managers (1Password, Bitwarden, etc.)     | `cards/password-managers/`   |
| Errors, debugging, broken state                    | `cards/troubleshooting/`     |
| Install / setup / new machine                      | `cards/installation/`        |
| How-to patterns, workflows, Docker, CI             | `cards/recipes/`             |

## Answering strategy

- If the question is about a specific command, check `cards/commands/` first.
- If the question is "how do I..." or a workflow question, check `cards/recipes/` first, then relevant category.
- If the question involves templates or conditionals, check `cards/templates/` first.
- If the question involves an error or something not working, check `cards/troubleshooting/` first.
- If the question involves secrets or credentials, check `cards/password-managers/` and `cards/encryption/`.
- For questions about .chezmoiexternal or pulling files from URLs, check `cards/externals/`.
- When multiple cards are relevant, synthesize an answer from all of them.

## Fallback

1. If the cards don't cover the user's question, fall back to reading the source documentation at `<repo-root>/src/`. The source docs are organized as described in the project's CLAUDE.md lookup table.

2. If the answer still cannot be found in cards or documentation — particularly for troubleshooting, understanding internal behavior, or verifying undocumented edge cases — inspect the chezmoi source code in the upstream repository at `https://github.com/twpayne/chezmoi`. Use `WebFetch` to read relevant Go source files (e.g. `internal/cmd/`, `internal/chezmoi/`) to find the ground truth.

## Important context about chezmoi

- chezmoi manages dotfiles across multiple machines using a source-state model
- Source directory: `~/.local/share/chezmoi` (default)
- Config file: `~/.config/chezmoi/chezmoi.toml` (TOML/YAML/JSON supported)
- Templates use Go's `text/template` syntax extended with sprig functions
- File naming in source state encodes attributes (dot_, private_, executable_, encrypted_, etc.)
- Scripts prefixed with `run_` execute on `chezmoi apply`
- External files from URLs via `.chezmoiexternal.toml`
- Password manager integration via template functions
