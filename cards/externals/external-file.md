---
id: external-file
title: "External type=file: Pull Single Files from URLs"
category: externals
tags: [external, config, file-type]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoiexternal-format.md
related: [external-overview, external-archive, external-git-repo]
---

## Summary

The `file` external type downloads a single file from a URL and places it at a specified target path, as if it were a file in the chezmoi source state. This is useful for standalone scripts, plugins, or configuration files hosted remotely.

## Syntax / Usage

```toml
["<target-path>"]
    type = "file"
    url = "https://example.com/path/to/file"
    executable = false    # optional: make file executable
    private = false       # optional: set permissions to 0o600
    readonly = false      # optional: set read-only permissions
    refreshPeriod = "168h" # optional: re-download interval
    decompress = "gzip"   # optional: decompress before writing
```

## Details

- The target is a file whose contents come from the downloaded URL.
- **`executable`**: When `true`, the target file gets executable permissions.
- **`private`**: When `true`, permissions are set to 0o600.
- **`readonly`**: When `true`, read-only permissions are applied.
- **`decompress`**: Specifies decompression to apply before writing. Supported formats: `bzip2`, `gzip`, `xz`, `zstd`. Note: `.rar` and `.zip` are archives, not single compressed files -- use `archive-file` type to extract from those.
- **`encrypted`**: When `true`, the downloaded file is decrypted before writing.
- **`filter.command`/`filter.args`**: Pipe downloaded data through an external command before writing to target.
- **`refreshPeriod`**: Duration controlling re-download frequency. Default is `0` (never re-download unless forced with `chezmoi -R apply`).
- **`checksum.sha256`/`checksum.sha384`/`checksum.sha512`/`checksum.size`**: Optional integrity verification of downloaded data.
- chezmoi caches downloaded files locally between runs.

## Examples

Include vim-plug as a single file:

```toml
[".vim/autoload/plug.vim"]
    type = "file"
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    refreshPeriod = "168h"
```

Download an executable script:

```toml
[".local/bin/my-tool"]
    type = "file"
    url = "https://example.com/releases/my-tool-linux-amd64"
    executable = true
    refreshPeriod = "672h"
```

Download a gzip-compressed file:

```toml
[".local/share/dict/words"]
    type = "file"
    url = "https://example.com/words.gz"
    decompress = "gzip"
```

With checksum verification:

```toml
[".local/bin/sometool"]
    type = "file"
    url = "https://example.com/sometool-v1.2.3"
    executable = true
    checksum.sha256 = "abc123def456..."
```

## Caveats / Common Mistakes

- Do not confuse `decompress` (for single compressed files like `.gz`) with archive extraction. For `.zip` or `.rar` files containing multiple entries, use `archive-file` type instead.
- Without a `refreshPeriod`, the file is downloaded once and never updated unless you pass `-R`/`--refresh-externals`.
- Large files are validated on every `chezmoi diff`/`apply`/`verify`. For very large files, prefer a `run_onchange_` script.

## See Also

- external-overview
- external-archive
- external-git-repo
