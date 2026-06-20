---
id: cmd-init
title: "chezmoi init"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/init.md
related: [cmd-apply, cmd-update]
---

## Summary

Sets up the source directory, generates the config file from a template, and optionally applies the target state. This is the entry point for bootstrapping chezmoi on a new machine.

## Syntax / Usage

```sh
chezmoi init [flags] [repo]
```

## Details

The init command performs the following steps in order:

1. Initializes the source directory. If no Git repository is detected, clones the provided *repo* or initializes a new Git repository.
2. If a `.chezmoi.$FORMAT.tmpl` config template exists in the source directory, generates a new config file from it.
3. If `--apply` is provided, runs `chezmoi apply`.
4. If `--purge` is provided, removes the source, config, and cache directories.
5. If `--purge-binary` is provided, attempts to remove the chezmoi binary itself.

Repo URL guessing (enabled by default, disable with `--guess-repo-url=false`):

| Pattern            | HTTPS Repo                                  | SSH Repo                           |
| ------------------ | ------------------------------------------- | ---------------------------------- |
| `user`             | `https://user@github.com/user/dotfiles.git` | `git@github.com:user/dotfiles.git` |
| `user/repo`        | `https://user@github.com/user/repo.git`     | `git@github.com:user/repo.git`     |
| `site/user/repo`   | `https://user@site/user/repo.git`           | `git@site:user/repo.git`           |
| `sr.ht/~user`      | `https://user@git.sr.ht/~user/dotfiles`     | `git@git.sr.ht:~user/dotfiles.git` |
| `sr.ht/~user/repo` | `https://user@git.sr.ht/~user/repo`         | `git@git.sr.ht:~user/repo.git`     |

Key flags:

- `-a`, `--apply` -- Run `chezmoi apply` after init.
- `--branch` *branch* -- Check out a specific branch.
- `-C`, `--config-path` *path* -- Write generated config to a custom path.
- `--data` *bool* -- Include existing template data when generating config (default: true).
- `-d`, `--depth` *depth* -- Shallow clone with the given depth.
- `--git-lfs` *bool* -- Run `git lfs pull` after cloning.
- `-g`, `--guess-repo-url` *bool* -- Enable/disable repo URL guessing (default: true).
- `--one-shot` -- Equivalent to `--apply --depth=1 --force --purge --purge-binary`. For temporary environments like Docker containers.
- `--prompt` -- Force `prompt*Once` functions to prompt.
- `--promptBool`, `--promptChoice`, `--promptDefaults`, `--promptInt`, `--promptMultichoice`, `--promptString` -- Pre-populate prompt template functions with values.
- `-p`, `--purge` -- Remove source and config directories after applying.
- `-P`, `--purge-binary` -- Remove the chezmoi binary after applying.
- `--recurse-submodules` *bool* -- Recursively clone submodules (default: true).
- `--ssh` -- Guess SSH repo URL instead of HTTPS.

## Examples

```sh
# Initialize from a GitHub user's dotfiles repo
chezmoi init user

# Initialize and immediately apply
chezmoi init user --apply

# Initialize, apply, then clean up (for ephemeral environments)
chezmoi init user --apply --purge

# Initialize from a specific user/repo
chezmoi init user/dots

# Initialize from Codeberg or GitLab
chezmoi init codeberg.org/user
chezmoi init gitlab.com/user

# One-shot for Docker containers
chezmoi init --one-shot user
```

## Caveats / Common Mistakes

- If using a version control system other than Git, you must create an empty `.git` directory in the source directory to prevent chezmoi from trying to clone or initialize a Git repository: `mkdir -p ~/.local/share/chezmoi/.git`.
- `--one-shot` removes chezmoi entirely after applying -- only use in ephemeral environments.
- The `--promptDefaults` flag causes all prompt functions with a default value to return that default without prompting, which is useful for non-interactive CI/CD but may skip important configuration choices.

## See Also

- cmd-apply
- cmd-update
