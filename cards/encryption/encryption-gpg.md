---
id: encryption-gpg
title: Encrypting files with GPG in chezmoi
category: encryption
tags: [encryption, config, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/encryption/gpg.md
related: [encryption-overview, encryption-age]
---

## Summary

chezmoi supports encrypting files with GPG using either asymmetric (public/private key) or symmetric encryption. Encrypted files are stored in the source state and automatically decrypted when generating the target state or editing with `chezmoi edit`.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "gpg"
[gpg]
    recipient = "..."
```

## Details

### Asymmetric (public-key) encryption

Specify the GPG recipient (key ID or email) in the configuration. chezmoi runs the equivalent of:

```sh
gpg --armor --recipient $RECIPIENT --encrypt
```

The encrypted file is stored in the source state in ASCII-armored format and automatically decrypted when generating the target state.

### Symmetric encryption

Set `symmetric = true` in the `[gpg]` section. chezmoi runs the equivalent of:

```sh
gpg --armor --symmetric
```

### Passphrase-based encryption with stored passphrase

You can store the passphrase in the chezmoi config template so it is prompted only once during `chezmoi init` on a new machine:

```text title="~/.local/share/chezmoi/.chezmoi.toml.tmpl"
{{ $passphrase := promptStringOnce . "passphrase" "passphrase" -}}

encryption = "gpg"
[data]
    passphrase = {{ $passphrase | quote }}
[gpg]
    symmetric = true
    args = ["--batch", "--passphrase", {{ $passphrase | quote }}, "--no-symkey-cache"]
```

### Muting GPG output

GPG sends info messages to stderr. To suppress them, add `--quiet` to `gpg.args`:

```toml title="~/.config/chezmoi/chezmoi.toml"
[gpg]
    args = ["--quiet"]
```

## Examples

Asymmetric encryption with a GPG key:

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "gpg"
[gpg]
    recipient = "john@example.com"
```

Symmetric encryption (prompts for passphrase each time):

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "gpg"
[gpg]
    symmetric = true
```

Store passphrase in config template (prompted only once at init):

```text title="~/.local/share/chezmoi/.chezmoi.toml.tmpl"
{{ $passphrase := promptStringOnce . "passphrase" "passphrase" -}}

encryption = "gpg"
[data]
    passphrase = {{ $passphrase | quote }}
[gpg]
    symmetric = true
    args = ["--batch", "--passphrase", {{ $passphrase | quote }}, "--no-symkey-cache"]
```

Suppress GPG info messages:

```toml title="~/.config/chezmoi/chezmoi.toml"
[gpg]
    args = ["--quiet"]
```

## Caveats / Common Mistakes

- The `encryption = "gpg"` line must be at the top level of the config file, before the `[gpg]` section.
- GPG sends informational messages to stderr; redirect or use `--quiet` in `gpg.args` to suppress them.
- When using the passphrase template approach, the passphrase is stored in plaintext in the chezmoi config file on each machine. This is acceptable only if you trust local machine security.
- The `--no-symkey-cache` flag prevents GPG from caching the symmetric key, which is needed when providing the passphrase via `--passphrase` argument.

## See Also

- encryption-overview
- encryption-age
