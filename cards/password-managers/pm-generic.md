---
id: pm-generic
title: Generic Secret Command Integration
category: password-managers
tags: [password-manager, template, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/password-managers/custom.md
related: [pm-overview, pm-1password, pm-bitwarden]
---

## Summary

chezmoi can integrate with any command-line secret manager through the generic `secret` and `secretJSON` template functions. You configure which binary to invoke via `secret.command` in the chezmoi config, then call it with arbitrary arguments from templates.

## Syntax / Usage

```text
{{ secret "arg1" "arg2" ... }}
{{ secretJSON "arg1" "arg2" ... }}
```

Configuration:

```toml
[secret]
    command = "your-secret-cli"
    args = ["optional", "default", "args"]
```

## Details

**`secret`** invokes the command specified by `secret.command` with `secret.args` prepended to the provided arguments. It returns the raw output as a string with leading and trailing whitespace removed.

**`secretJSON`** works identically but parses the output as JSON and returns structured data.

Both functions cache output per unique argument set, so repeated calls with the same arguments invoke the external command only once per chezmoi run.

The `secret.args` config variable provides default arguments prepended to every invocation, useful for flags like `--format=json` that should always be present.

**Supported managers via generic secret command:**

| Secret Manager | `secret.command` | Template usage |
| --- | --- | --- |
| 1Password | `op` | `{{ secretJSON "get" "item" "$ID" }}` |
| Bitwarden | `bw` | `{{ secretJSON "get" "$ID" }}` |
| Doppler | `doppler` | `{{ secretJSON "secrets" "download" "--json" "--no-file" }}` |
| HashiCorp Vault | `vault` | `{{ secretJSON "kv" "get" "-format=json" "$ID" }}` |
| LastPass | `lpass` | `{{ secretJSON "show" "--json" "$ID" }}` |
| KeePassXC | `keepassxc-cli` | Not possible (interactive command only) |
| Keeper | `keeper` | `{{ secretJSON "get" "--format=json" "$ID" }}` |
| pass | `pass` | `{{ secret "show" "$ID" }}` |
| passhole | `ph` | `{{ secret "$ID" "password" }}` |
| Proton Pass | `pass-cli` | `{{ secretJSON "item" "view" "$ID" "--output=json" }}` |

## Examples

Using `pass` as the secret backend:

```toml title="~/.config/chezmoi/chezmoi.toml"
[secret]
    command = "pass"
```

```text
{{ secret "show" "email/password" }}
```

Using HashiCorp Vault:

```toml title="~/.config/chezmoi/chezmoi.toml"
[secret]
    command = "vault"
```

```text
{{ (secretJSON "kv" "get" "-format=json" "secret/data/myapp").data.data.password }}
```

Using Doppler to get all secrets:

```toml title="~/.config/chezmoi/chezmoi.toml"
[secret]
    command = "doppler"
```

```text
{{ (secretJSON "secrets" "download" "--json" "--no-file").MY_SECRET }}
```

Using LastPass:

```toml title="~/.config/chezmoi/chezmoi.toml"
[secret]
    command = "lpass"
```

```text
{{ (index (secretJSON "show" "--json" "example.com") 0).password }}
```

## Caveats / Common Mistakes

- KeePassXC cannot be used with the generic secret command because `keepassxc-cli` requires interactive input.
- `secret.command` must be set in the config file before `secret` or `secretJSON` template functions can be used.
- The generic secret functions are an alternative to the dedicated template functions. For 1Password and Bitwarden, the dedicated functions (e.g., `onepasswordRead`, `bitwarden`) provide richer integration and are preferred.
- Whitespace is only trimmed for `secret` (raw output), not for `secretJSON` (which parses JSON directly).

## See Also

- pm-overview
- pm-1password
- pm-bitwarden
