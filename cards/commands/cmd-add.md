---
id: cmd-add
title: "chezmoi add"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/add.md
related: [cmd-apply, cmd-edit]
---

## Summary

Adds target files to the chezmoi source state. If a target is already managed, its source state is replaced with the current state from the destination directory.

## Syntax / Usage

```sh
chezmoi add [flags] target...
```

## Details

Key flags:

- `-a`, `--autotemplate` -- Automatically generate a template by replacing strings matching config data values with template expressions. Implies `--template`. Uses a greedy algorithm that may produce unwanted substitutions.
- `--create` -- Add files with the `create_` attribute (only create if target does not exist; never overwrite).
- `--encrypt` -- Encrypt the file using the configured encryption method. Configuration: `add.encrypt`.
- `--exact` -- Set the `exact` attribute on added directories (stateful sync: files not in source are removed from target on apply).
- `--follow` -- If the target is a symlink, add the symlink's target instead of the symlink itself.
- `--new` -- Create a new file if the target does not exist.
- `-p`, `--prompt` -- Interactively prompt before adding each file.
- `-q`, `--quiet` -- Suppress warnings about adding ignored entries.
- `--secrets` `ignore`|`warning`|`error` -- Action when a secret is detected. Defaults to `warning`. Configuration: `add.secrets`.
- `-T`, `--template` -- Set the `template` attribute on added files and symlinks.
- `--template-symlinks` -- For symlinks to absolute paths in source/destination, create a symlink template using `.chezmoi.sourceDir` or `.chezmoi.homeDir`. Configuration: `add.templateSymlinks`.
- `-f`, `--force` -- Add targets even if doing so would overwrite a source template.
- `-r`, `--recursive` -- Recurse into directories (defaults to true).
- `-x`, `--exclude` *types* -- Exclude target types.
- `-i`, `--include` *types* -- Only include specified target types.

## Examples

```sh
# Add a single file
chezmoi add ~/.bashrc

# Add a file as a template
chezmoi add ~/.gitconfig --template

# Add an encrypted file
chezmoi add ~/.ssh/id_rsa --encrypt

# Recursively add a directory
chezmoi add ~/.vim --recursive

# Add a directory with exact attribute
chezmoi add ~/.oh-my-zsh --exact --recursive
```

## Caveats / Common Mistakes

- `chezmoi add` will fail if the entry being added is in a directory implicitly created by an external (see issue #1574).
- `--autotemplate` uses a greedy algorithm that can generate templates with unwanted variable substitutions. Always review generated templates carefully.
- `chezmoi add --exact --recursive DIR` on a nested directory can have surprising results. If you run `chezmoi add --exact --recursive ~/.config/nvim` without previously adding files from `~/.config`, chezmoi considers all of `~/.config` managed with `exact` -- any file not in `~/.config/nvim` will be removed on the next apply. To prevent this, add a `.keep` file to the parent directory first:

  ```sh
  touch ~/.config/.keep
  chezmoi add ~/.config/.keep
  chezmoi add --recursive --exact ~/.config/nvim
  ```

## See Also

- cmd-apply
- cmd-edit
