---
id: recipe-docker
title: Using Chezmoi in Containers and Codespaces
category: recipes
tags: [recipe, installation, template]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/machines/containers-and-vms.md
related: [recipe-new-machine, recipe-ignore]
---

## Summary

chezmoi can manage dotfiles in containers, GitHub Codespaces, VS Code Remote Containers, and other transient environments. The key differences from a regular machine setup are: the repo is pre-cloned to `~/dotfiles`, the installation must be non-interactive, and `--one-shot` mode removes chezmoi after applying.

## Syntax / Usage

```sh
# One-shot install for transient containers (installs, applies, then removes chezmoi)
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --one-shot $GITHUB_USERNAME

# Standard install + apply for persistent containers
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

# Generate install.sh for Codespaces
chezmoi generate install.sh > install.sh
chmod a+x install.sh
```

## Details

**GitHub Codespaces / VS Code Remote Containers** automatically clone your `dotfiles` repo to `~/dotfiles`. The environment variable `CODESPACES` is set to `true` when running in a Codespace.

The workflow differs from a regular machine:
1. The dotfiles repo is already cloned (no need for `chezmoi init $REPO`).
2. The installation script must be non-interactive (no prompts).
3. The `sourceDir` config must point to where Codespaces clones the repo.

**Non-interactive config template**: Detect the `CODESPACES` environment variable and skip prompts:

```text title="~/.local/share/chezmoi/.chezmoi.toml.tmpl"
{{- $codespaces:= env "CODESPACES" | not | not -}}
sourceDir = {{ .chezmoi.sourceDir | quote }}

[data]
    name = "Your name"
    codespaces = {{ $codespaces }}
{{- if $codespaces }}
    email = "your@email.com"
{{- else }}
    email = {{ promptString "email" | quote }}
{{- end }}
```

Setting `sourceDir` to `.chezmoi.sourceDir` is required because Codespaces clones dotfiles to a different location than chezmoi's default.

**install.sh for Codespaces**: Use `chezmoi generate install.sh` to create the installation script. Add it to `.chezmoiignore` so chezmoi does not try to manage it in the target directory.

**One-shot mode** (`--one-shot`): Installs dotfiles and then removes all traces of chezmoi (source directory, config directory, binary). Ideal for short-lived containers where you want dotfiles applied but no ongoing management.

## Examples

Dockerfile using one-shot mode:

```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl git
RUN sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --one-shot $GITHUB_USERNAME
```

Conditionally skip package installation in Codespaces:

```text title="run_onchange_install-packages.sh.tmpl"
{{- if (and (eq .chezmoi.os "linux") (not .codespaces)) -}}
#!/bin/sh
sudo apt install -y vim-gtk
{{- end -}}
```

Generate and commit install.sh for Codespaces:

```sh
chezmoi generate install.sh > install.sh
chmod a+x install.sh
echo install.sh >> .chezmoiignore
git add install.sh .chezmoiignore
git commit -m "Add install.sh"
```

Use the `codespaces` template variable in dotfiles:

```text title="dot_bashrc.tmpl"
{{- if not .codespaces }}
# Only load on real machines
source ~/.local/share/bash-completion
{{- end }}
```

## Caveats / Common Mistakes

- You must set `sourceDir` in the config template when using Codespaces, because the repo is cloned to a non-default location.
- The `env "CODESPACES" | not | not` pattern converts the string to a boolean (empty string becomes false, any non-empty string becomes true).
- `--one-shot` removes everything after apply -- do not use it on machines where you want ongoing dotfile management.
- The `install.sh` script should be added to `.chezmoiignore` to prevent chezmoi from attempting to manage it in the home directory.

## See Also

- recipe-new-machine
- recipe-ignore
