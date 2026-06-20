---
id: external-git-repo
title: "External type=git-repo: Clone and Pull Git Repositories"
category: externals
tags: [external, config, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoiexternal-format.md
related: [external-overview, external-archive, external-file]
---

## Summary

The `git-repo` external type keeps a git repository cloned and up-to-date in a target subdirectory. chezmoi runs `git clone` if the directory does not exist, or `git pull` if it does. This is useful for plugins, themes, or tools distributed as git repositories.

## Syntax / Usage

```toml
["<target-directory>"]
    type = "git-repo"
    url = "https://github.com/user/repo.git"
    refreshPeriod = "168h"  # optional: how often to git pull
    clone.args = ["--depth", "1"]  # optional: extra args for git clone
    pull.args = ["--ff-only"]      # optional: extra args for git pull
```

## Details

- If the target directory does not exist, chezmoi runs `git clone $URL $TARGET` with any additional `clone.args`.
- If the target directory already exists, chezmoi runs `git pull` (with optional `pull.args`) to update it, but no more often than every `refreshPeriod`.
- The default `refreshPeriod` is `0`, meaning chezmoi never pulls automatically. Use `-R`/`--refresh-externals` to force a pull.
- You must have a `git` binary in your `$PATH`.
- Using `git-repo` delegates full management of that directory to git. chezmoi cannot manage other files inside a `git-repo` external directory.
- The contents of `git-repo` externals are NOT manifested in `chezmoi diff` or `chezmoi dump` output, and the directory will be listed by `chezmoi unmanaged`.
- For private repositories, use an SSH URL (e.g., `git@github.com:org/repo.git`). Ensure the SSH key is available, potentially configured via a `before_` script. Use the `stat` template function to conditionally include the entry only when the key exists.

## Examples

Basic git-repo external:

```toml
[".vim/pack/alker0/chezmoi.vim"]
    type = "git-repo"
    url = "https://github.com/alker0/chezmoi.vim.git"
    refreshPeriod = "168h"
```

With custom pull arguments:

```toml
[".vim/pack/alker0/chezmoi.vim"]
    type = "git-repo"
    url = "https://github.com/alker0/chezmoi.vim.git"
    refreshPeriod = "168h"
    [".vim/pack/alker0/chezmoi.vim".pull]
        args = ["--ff-only"]
```

Shallow clone to save bandwidth:

```toml
[".tmux/plugins/tpm"]
    type = "git-repo"
    url = "https://github.com/tmux-plugins/tpm.git"
    refreshPeriod = "168h"
    [".tmux/plugins/tpm".clone]
        args = ["--depth", "1"]
```

Private repository with conditional inclusion:

```toml
{{ if stat (joinPath .chezmoi.homeDir ".ssh" "id_rsa") }}
[".path/to/private/repo"]
    type = "git-repo"
    url = "git@private.com:org/repo.git"
{{ end }}
```

## Caveats / Common Mistakes

- chezmoi's `git-repo` support is limited to `git clone` and `git pull`. No branch switching, reset, or other git operations are performed.
- chezmoi cannot manage individual files inside a `git-repo` directory. If you need to manage extra files alongside the repo contents, use an `archive` external pointing to the repo's tarball URL instead.
- `git-repo` contents do not appear in `chezmoi diff` or `chezmoi dump`. This can be surprising when verifying state.
- The directory will appear in `chezmoi unmanaged` output since chezmoi delegates management to git.
- If you need a specific tag or branch, use `clone.args` with `--branch <tag>` to control what is checked out.

## See Also

- external-overview
- external-archive
- external-file
