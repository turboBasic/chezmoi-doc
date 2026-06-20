---
id: external-archive
title: "External type=archive: Pull Directories from URLs"
category: externals
tags: [external, config, file-type]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoiexternal-format.md
related: [external-overview, external-file, external-git-repo]
---

## Summary

The `archive` external type downloads an archive from a URL and extracts it into a target directory as if its contents were part of the chezmoi source state. This is the primary mechanism for including third-party dotfile collections (e.g., Oh My Zsh, themes, plugins) without storing them in your source repo.

## Syntax / Usage

```toml
["<target-directory>"]
    type = "archive"
    url = "https://example.com/repo/archive/master.tar.gz"
    exact = true          # optional: treat as exact directory (remove extra files)
    stripComponents = 1   # optional: strip N leading path components
    format = "tar.gz"     # optional: override auto-detected format
    refreshPeriod = "168h" # optional: re-download interval
    include = ["*/src/**"] # optional: glob patterns to include
    exclude = ["*/test/**"] # optional: glob patterns to exclude
```

## Details

- The target is a directory populated with the contents of the archive at the given URL.
- **`exact`**: When `true`, the directory and all subdirectories are treated as exact directories. On `chezmoi apply`, files not present in the archive are removed from the target.
- **`stripComponents`**: Removes the specified number of leading directory components from archive members. Commonly set to `1` to strip the repository name prefix from GitHub tarballs.
- **`format`**: Supported archive formats are `tar`, `tar.gz` (alias `tgz`), `tar.bz2` (alias `tbz2`), `xz`, `.tar.zst`, and `zip`. If not specified, chezmoi guesses from the URL path and then from file contents.
- **`include`/`exclude`**: Glob patterns that match paths within the archive (not target paths). The inclusion algorithm is:
  1. If a member matches any `exclude` pattern, it is excluded (recursively for directories).
  2. Otherwise, if it matches any `include` pattern, it is included.
  3. If only `include` patterns are specified, non-matching members are excluded.
  4. If only `exclude` patterns are specified, non-matching members are included.
  5. Otherwise, the member is included.
- **`filter.command`/`filter.args`**: Pipe downloaded data through an external command before archive extraction (useful for unsupported compression formats).
- **`archive.extractAppleDouble`**: Controls extraction of AppleDouble files (default `false`).
- **`targetPath`**: Overrides the entry key as the target path, allowing multiple archive entries to extract into the same directory.
- chezmoi caches downloaded archives locally. The `refreshPeriod` controls re-download frequency (default `0` = never unless `-R` flag is used).

## Examples

Include Oh My Zsh with a plugin and theme:

```toml
[".oh-my-zsh"]
    type = "archive"
    url = "https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz"
    exact = true
    stripComponents = 1
    refreshPeriod = "168h"

[".oh-my-zsh/custom/plugins/zsh-syntax-highlighting"]
    type = "archive"
    url = "https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz"
    exact = true
    stripComponents = 1
    refreshPeriod = "168h"

[".oh-my-zsh/custom/themes/powerlevel10k"]
    type = "archive"
    url = "https://github.com/romkatv/powerlevel10k/archive/v1.15.0.tar.gz"
    exact = true
    stripComponents = 1
```

Include only selected files from an archive:

```toml
[".oh-my-zsh/custom/plugins/zsh-syntax-highlighting"]
    type = "archive"
    url = "https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz"
    exact = true
    stripComponents = 1
    refreshPeriod = "168h"
    include = ["*/*.zsh", "*/.version", "*/.revision-hash", "*/highlighters/**"]
```

Use `filter` for unsupported compression:

```toml
[".Software/anki/2.1.54-qt6"]
    type = "archive"
    url = "https://github.com/ankitects/anki/releases/download/2.1.54/anki-2.1.54-linux-qt6.tar.zst"
    filter.command = "zstd"
    filter.args = ["-d"]
    format = "tar"
```

Multiple archives into one target directory using `targetPath`:

```toml
[p10k_fonts]
    type = "archive"
    url = "https://github.com/romkatv/powerlevel10k-media/archive/master.tar.gz"
    exact = false
    stripComponents = 1
    refreshPeriod = "168h"
    include = ["*/*.ttf"]
    targetPath = "Library/Fonts"

[source_code_pro]
    type = "archive"
    url = "https://github.com/adobe-fonts/source-code-pro/archive/master.tar.gz"
    exact = false
    stripComponents = 2
    refreshPeriod = "168h"
    include = ["**/*.ttf"]
    targetPath = "Library/Fonts"
```

## Caveats / Common Mistakes

- Do not use externals for very large archives. chezmoi validates contents on every `diff`/`apply`/`verify`. Use `run_onchange_` scripts for large archives instead.
- GitHub tarballs typically have a top-level directory like `repo-branch/`, so `stripComponents = 1` is almost always needed.
- When `exact = true`, any files in the target directory that are not in the archive will be deleted on `chezmoi apply`. Be careful with directories that accumulate runtime caches.
- Add cache directories generated at runtime (e.g., `.oh-my-zsh/cache/`) to `.chezmoiignore` to avoid spurious diffs.

## See Also

- external-overview
- external-file
- external-git-repo
