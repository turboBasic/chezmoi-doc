---
id: concept-target-state
title: "Target State"
category: concepts
tags: [concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/concepts.md
related: [concept-source-state, concept-destination-state, concept-application-order]
---

## Summary

The target state is the computed desired state of the destination directory. It is derived from the source state, the config file, and the destination state, and represents exactly what chezmoi will make your dotfiles look like when you run `chezmoi apply`.

## Details

The target state is not stored on disk -- it is computed at runtime by chezmoi. It is produced by evaluating templates in the source state using data from the config file and (in some cases) the current destination state (e.g., for `modify_` scripts that receive the existing file contents on stdin).

Unlike the source state (which contains only regular files and directories), the target state can include:

- Regular files
- Directories
- Symbolic links
- Scripts to be run
- Targets to be removed

A **target** is any file, directory, or symlink in the destination directory that chezmoi manages. Target names are determined by stripping all attribute prefixes and suffixes from source file names (e.g., `dot_bashrc.tmpl` becomes `.bashrc`).

chezmoi calculates the desired contents for each dotfile and then makes the minimum changes required to make the destination match the target state.

## Examples

Preview the target state (what chezmoi wants to apply) without making changes:

```sh
chezmoi diff
```

Dry-run with verbose output to see exactly what would change:

```sh
chezmoi apply -n -v
```

View computed contents of a specific target:

```sh
chezmoi cat ~/.bashrc
```

Execute a template to see its output (useful for debugging):

```sh
chezmoi execute-template '{{ .chezmoi.os }}'
```

## See Also

- concept-source-state
- concept-destination-state
- concept-application-order
