---
id: recipe-new-machine
title: Setting Up Chezmoi on a New Machine
category: recipes
tags: [recipe, command, installation]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/daily-operations.md
related: [recipe-quick-start, recipe-docker]
---

## Summary

How to install chezmoi and apply your dotfiles on a new machine, ranging from a two-step process to a single one-liner that installs chezmoi, clones your repo, and applies everything.

## Syntax / Usage

```sh
# Option 1: Two-step (init then apply)
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
chezmoi apply -v

# Option 2: Single command (init + apply)
chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git

# Option 3: Shorthand for GitHub repos named "dotfiles"
chezmoi init --apply $GITHUB_USERNAME

# Option 4: Install chezmoi and dotfiles in one shell command
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

# Option 5: One-shot for transient environments (removes chezmoi after applying)
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --one-shot $GITHUB_USERNAME
```

## Details

`chezmoi init $REPO` clones the dotfiles repository into `~/.local/share/chezmoi` and checks out any submodules. If the repo contains a `.chezmoi.$FORMAT.tmpl` config file template (where `$FORMAT` is `toml`, `yaml`, `json`, or `jsonc`), `chezmoi init` executes that template to generate the initial config file.

The `--apply` flag combines init + apply into one step. After initialization, you can preview changes with `chezmoi diff` before applying.

The `--one-shot` flag is designed for transient environments (short-lived containers, CI). It installs dotfiles and then removes all traces of chezmoi, including the source directory and configuration.

For private GitHub repos, use SSH authentication:

```sh
chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git
```

To pull and apply updates on an existing machine:

```sh
chezmoi update -v
```

This runs `git pull --autostash --rebase` in the source directory followed by `chezmoi apply`.

## Examples

Automatic config file creation with `.chezmoi.toml.tmpl`:

```text title="~/.local/share/chezmoi/.chezmoi.toml.tmpl"
{{- $email := promptStringOnce . "email" "Email address" -}}

[data]
    email = {{ $email | quote }}
```

When `chezmoi init` runs on a new machine, it prompts for the email address (only if not already set) and generates `~/.config/chezmoi/chezmoi.toml`.

To test the config template:

```sh
chezmoi execute-template --init --promptString "Email address=me@home.org" < ~/.local/share/chezmoi/.chezmoi.toml.tmpl
```

Pull latest changes and preview before applying:

```sh
chezmoi git pull -- --autostash --rebase && chezmoi diff
# If happy with changes:
chezmoi apply
```

## Caveats / Common Mistakes

- Without `--ssh`, private GitHub repos require a personal access token when prompted for a password (not your GitHub password).
- If you change your config file template, run `chezmoi init` again to re-generate the config. Use `promptStringOnce` instead of `promptString` to avoid being re-prompted for values already in your data.
- `chezmoi update` is the idiomatic way to pull and apply on existing machines -- do not manually `git pull` inside the source directory and then `chezmoi apply` unless you need to preview first.

## See Also

- recipe-quick-start
- recipe-docker
