---
id: external-overview
title: ".chezmoiexternal: Include Files from External Sources"
category: externals
tags: [external, concept, config, file-type]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoiexternal-format.md
related: [external-archive, external-file, external-git-repo]
---

## Summary

`.chezmoiexternal.$FORMAT` is a special file (TOML, YAML, or JSON) that declares external files, archives, and git repositories to be included in the target state as if they were part of the source state. It allows chezmoi to pull dotfiles, plugins, and tools from URLs without storing them directly in the source directory.

## Syntax / Usage

```toml
# ~/.local/share/chezmoi/.chezmoiexternal.toml
["<target-path-relative-to-file-location>"]
    type = "file" | "archive" | "archive-file" | "git-repo"
    url = "https://..."
    # optional fields depending on type
```

The file can be placed anywhere in the source state. Entries are indexed by target name relative to the directory containing the `.chezmoiexternal.$FORMAT` file.

## Details

- The file format must be one of chezmoi's supported config formats: TOML, YAML, or JSON.
- The file is always interpreted as a template (whether or not it has a `.tmpl` extension), allowing conditional inclusion of externals per machine.
- Each entry requires a `type` field (`file`, `archive`, `archive-file`, or `git-repo`) and a `url` field (must be `https://`, `http://`, or `file://`).
- An optional `urls` field provides fallback URLs tried in order.
- If parent directories of an entry do not exist in the source state, chezmoi creates them as regular directories.
- If the `.chezmoiexternal.$FORMAT` file is in a directory listed in `.chezmoiignore`, all its entries are also ignored.
- Optional checksum fields (`checksum.sha256`, `checksum.sha384`, `checksum.sha512`, `checksum.size`) verify downloaded data integrity.
- The `encrypted` boolean field specifies whether the external is encrypted.
- The `filter.command` and `filter.args` fields pipe downloaded data through an external command before processing.
- The `refreshPeriod` field (a duration like `168h`) controls how often chezmoi re-downloads the URL. Default is `0` (never re-download unless forced with `-R`/`--refresh-externals`).
- The `targetPath` field overrides the entry key to specify a different target path, allowing multiple entries to target the same directory.
- `.chezmoiexternals/` directories can also hold external definitions (one file per external).

## Examples

Minimal example combining all types:

```toml
# ~/.local/share/chezmoi/.chezmoiexternal.toml

# Single file
[".vim/autoload/plug.vim"]
    type = "file"
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    refreshPeriod = "168h"

# Archive (directory)
[".oh-my-zsh"]
    type = "archive"
    url = "https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz"
    exact = true
    stripComponents = 1
    refreshPeriod = "168h"

# Git repository
[".vim/pack/alker0/chezmoi.vim"]
    type = "git-repo"
    url = "https://github.com/alker0/chezmoi.vim.git"
    refreshPeriod = "168h"
```

Force refresh of all externals:

```sh
chezmoi -R apply
```

Conditional inclusion using template logic:

```toml
{{ if stat (joinPath .chezmoi.homeDir ".ssh" "id_rsa") }}
[".path/to/private/repo"]
    type = "git-repo"
    url = "git@private.com:org/repo.git"
{{ end }}
```

## Caveats / Common Mistakes

- Do not use externals for large files or archives. chezmoi validates exact contents of externals on every `chezmoi diff`, `chezmoi apply`, or `chezmoi verify`. For large externals, use a `run_onchange_` script instead.
- External target directories that accumulate cache files during normal use (e.g., `.oh-my-zsh/cache/completions/`) will cause chezmoi to report changes. Add such paths to `.chezmoiignore`.
- When using Oh My Zsh as an external, disable its built-in auto-updates (`DISABLE_AUTO_UPDATE="true"`) to prevent the target drifting from source state.

## See Also

- external-archive
- external-file
- external-git-repo
