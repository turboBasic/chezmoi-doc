---
id: encryption-age
title: Encrypting files with age in chezmoi
category: encryption
tags: [encryption, config, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/encryption/age.md
related: [encryption-overview, encryption-gpg]
---

## Summary

chezmoi supports encrypting files with age, a modern file encryption tool, using public-key (recipient/identity) encryption, symmetric encryption, or passphrase-based symmetric encryption. chezmoi also has builtin age support that works without the `age` binary.

## Syntax / Usage

```sh
# Generate an age key
chezmoi age-keygen --output=$HOME/key.txt
```

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    identity = "/home/user/key.txt"
    recipient = "age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p"
```

## Details

### Key generation

Use `chezmoi age-keygen` to generate a new age key pair. The public key is printed to stdout, and the private key is written to the specified output file.

### Public-key encryption

Requires at least one identity (private key for decryption) and one recipient (public key for encryption). Multiple identities and recipients are supported via the `identities` and `recipients` list keys.

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    identities = ["/home/user/key1.txt", "/home/user/key2.txt"]
    recipients = ["recipient1", "recipient2"]
```

### Symmetric encryption

Uses a single identity file as the encryption key. Enable by setting `symmetric = true`.

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    identity = "~/.ssh/id_rsa"
    symmetric = true
```

### Passphrase-based symmetric encryption

Set `passphrase = true` to use a passphrase instead of a key file. You will be prompted for the passphrase on every operation that requires decryption (`add --encrypt`, `apply`, `diff`, `status`).

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    passphrase = true
```

### Builtin age encryption

chezmoi includes builtin age encryption support that is used automatically when the `age` command is not found in `$PATH`. This builtin implementation does **not** support:

- Passphrases (prompting on every diff/status would be impractical)
- Symmetric encryption
- SSH keys (the age project recommends only X25519 keys for integration)

## Examples

Generate a key and configure age encryption:

```sh
chezmoi age-keygen --output=$HOME/key.txt
# Public key: age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
```

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    identity = "/home/user/key.txt"
    recipient = "age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p"
```

Then add files with encryption:

```sh
chezmoi add --encrypt ~/.ssh/id_rsa
```

Symmetric encryption with an existing SSH key:

```toml title="~/.config/chezmoi/chezmoi.toml"
encryption = "age"
[age]
    identity = "~/.ssh/id_rsa"
    symmetric = true
```

## Caveats / Common Mistakes

- The `encryption = "age"` line must be at the top level of the config file, before the `[age]` section.
- The builtin age encryption does not support passphrases, symmetric encryption, or SSH keys. Install the `age` binary if you need these features.
- SSH keys are not recommended by the age project for automated integrations; use X25519 keys instead.
- Passphrase mode will prompt on every `diff`, `status`, and `apply` operation, which can become tedious for frequent use.

## See Also

- encryption-overview
- encryption-gpg
