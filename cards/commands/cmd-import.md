---
id: cmd-import
title: "chezmoi import -- Import archive into source state"
category: commands
tags: [command, external]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/import.md
related: [cmd-archive]
---

## Summary

Imports the contents of an archive file into the source state. Primarily used to make subdirectories of the home directory exactly match the contents of a downloaded archive (e.g., oh-my-zsh, vim plugins).

## Syntax / Usage

```sh
chezmoi import [flags] filename
```

## Details

Supported archive formats: `rar`, `tar`, `tar.gz`, `tgz`, `tar.bz2`, `tbz2`, `txz`, `tar.zst`, `zip`.

You will generally always want to set `--destination`, `--exact`, and `--remove-destination` flags.

Flags:
- `-d`, `--destination` *directory* -- set the destination in the source state where the archive is imported
- `--exact` -- set the `exact` attribute on all imported directories
- `-r`, `--remove-destination` -- remove the destination in the source state before importing
- `--strip-components` *n* -- strip n leading path components from archive paths
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types

## Examples

```sh
# Download and import oh-my-zsh into ~/.oh-my-zsh
curl -s -L -o ${TMPDIR}/oh-my-zsh-master.tar.gz https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz
mkdir -p $(chezmoi source-path)/dot_oh-my-zsh
chezmoi import --strip-components 1 --destination ~/.oh-my-zsh ${TMPDIR}/oh-my-zsh-master.tar.gz
```

## Caveats / Common Mistakes

- Without `--strip-components`, the top-level directory from the archive (e.g., `ohmyzsh-master/`) will be included in the path.
- Without `--exact`, chezmoi will not remove files that are in the destination but not in the archive.
- For ongoing sync of external archives, consider `.chezmoiexternal.*` instead of repeated imports.

## See Also

- cmd-archive
