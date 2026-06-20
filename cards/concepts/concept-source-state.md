---
id: concept-source-state
title: "Source State"
category: concepts
tags: [concept, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/concepts.md
related: [concept-target-state, concept-destination-state, concept-source-attributes, concept-working-tree]
---

## Summary

The source state declares the desired state of your home directory, stored as regular files and directories in the source directory. It is the single source of truth from which chezmoi computes what your dotfiles should look like on any machine.

## Details

The source state lives in the **source directory**, which defaults to `~/.local/share/chezmoi`. This location can be overridden with the `-S` flag or by setting `sourceDir` in the configuration file.

The source state contains only regular files and directories -- it does not contain symbolic links or scripts directly. Instead, these target types are encoded using filename prefixes (e.g., `symlink_`, `run_`) and suffixes (e.g., `.tmpl`). Templates within the source state use machine-specific data from the config file to produce different outputs on different machines.

chezmoi ignores all files and directories in the source directory that begin with a `.`, with the exception of those that begin with `.chezmoi`.

The source state includes special files (`.chezmoiignore`, `.chezmoiexternal.*`, `.chezmoidata.*`) and special directories (`.chezmoiscripts/`, `.chezmoitemplates/`, `.chezmoidata/`) that control chezmoi's behavior.

## Examples

Initialize chezmoi, creating the source directory:

```sh
chezmoi init
```

Add a file to the source state:

```sh
chezmoi add ~/.bashrc
# Creates ~/.local/share/chezmoi/dot_bashrc
```

Open a shell in the source directory:

```sh
chezmoi cd
```

View the source directory path:

```sh
chezmoi source-path
```

## Caveats / Common Mistakes

- The source state uses filename encoding (prefixes/suffixes) to represent target attributes. Renaming source files manually without understanding the prefix conventions will change the target behavior.
- chezmoi assumes the source state is not modified while chezmoi is running. Modifying source files in a `run_before_` script leads to undefined behavior.

## See Also

- concept-target-state
- concept-destination-state
- concept-source-attributes
- concept-working-tree
