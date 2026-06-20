---
id: encryption-overview
title: Encryption in chezmoi
category: encryption
tags: [encryption, concept, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/encryption/index.md
related: [encryption-age, encryption-gpg]
---

## Summary

chezmoi supports encrypting files with age, gpg, git-crypt, and transcrypt, storing them in ASCII-armored format in the source directory with the `encrypted_` attribute and automatically decrypting them when needed.

## Syntax / Usage

```sh
# Add a file with encryption
chezmoi add --encrypt ~/.ssh/id_rsa
```

## Details

Encrypted files are stored in the source state with the `encrypted_` prefix in their filename. When chezmoi generates the target state (via `apply`, `diff`, `status`, etc.), these files are automatically decrypted.

The `chezmoi edit` command transparently decrypts a file before opening it in the editor and re-encrypts it after editing.

Supported encryption backends:

- **age** — modern file encryption tool (also has builtin support in chezmoi)
- **gpg** — GNU Privacy Guard (asymmetric or symmetric)
- **git-crypt** — transparent git encryption
- **transcrypt** — transparent encryption in git repos

The `encryption` key must be set at the top level of the configuration file (before any other sections) to enable encryption.

The `encrypted_` prefix is allowed on regular files and create files in the source state. It can be combined with other prefixes such as `private_`, `readonly_`, `empty_`, `executable_`, and `dot_`.

## Examples

Add an SSH private key with encryption enabled:

```sh
chezmoi add --encrypt ~/.ssh/id_rsa
```

The file will be stored in the source state as something like:

```
~/.local/share/chezmoi/private_dot_ssh/encrypted_private_id_rsa
```

Edit an encrypted file transparently:

```sh
chezmoi edit ~/.ssh/id_rsa
```

## Caveats / Common Mistakes

- The `encryption` configuration key must appear at the top level of the config file, before any sections like `[age]` or `[gpg]`.
- Files must be added with `--encrypt` to be encrypted; adding without the flag stores them in plaintext.
- Changing encryption backends after files are already encrypted requires re-adding those files.

## See Also

- encryption-age
- encryption-gpg
