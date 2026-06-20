---
id: pm-overview
title: Password Manager Integration Overview
category: password-managers
tags: [password-manager, template, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/password-managers/custom.md
related: [pm-1password, pm-bitwarden, pm-generic]
---

## Summary

chezmoi integrates with password managers through template functions, allowing secrets to be retrieved at apply-time without storing them in the source state. Each supported password manager has dedicated template functions that invoke its CLI tool, cache the output, and return structured data.

## Details

chezmoi provides two categories of password manager integration:

**Dedicated template functions** for first-class password managers:

| Manager | Template functions | CLI tool |
| --- | --- | --- |
| 1Password | `onepassword`, `onepasswordRead`, `onepasswordDetailsFields`, `onepasswordDocument`, `onepasswordItemFields` | `op` |
| Bitwarden | `bitwarden`, `bitwardenFields`, `bitwardenAttachment`, `bitwardenAttachmentByRef`, `bitwardenSecrets` | `bw`, `bws` |
| Bitwarden (rbw) | `rbw`, `rbwFields` | `rbw` |

**Generic secret functions** for any CLI-based secret manager:

| Function | Behavior |
| --- | --- |
| `secret` | Returns raw string output from the configured command |
| `secretJSON` | Returns JSON-parsed structured data from the configured command |

All template function outputs are cached per unique set of arguments, so repeated calls with the same parameters invoke the external CLI only once.

Secrets are never stored in the chezmoi source state. They are fetched from the password manager each time `chezmoi apply` (or similar commands) evaluates templates.

## Examples

Using dedicated functions:

```text
# 1Password
{{ onepasswordRead "op://vault/item/field" }}

# Bitwarden
{{ (bitwarden "item" "example.com").login.password }}

# rbw
{{ (rbw "test-entry").data.password }}
```

Using the generic secret command:

```text
# pass
{{ secret "show" "email/password" }}

# HashiCorp Vault
{{ (secretJSON "kv" "get" "-format=json" "secret/data/myapp").data.password }}
```

## Caveats / Common Mistakes

- You must be authenticated with the password manager CLI before running chezmoi commands (unless auto-unlock is configured).
- Template functions invoke external CLIs; a missing or misconfigured CLI binary will cause template evaluation errors.
- Caching is per-chezmoi-invocation only. Each new `chezmoi apply` run will re-fetch secrets.

## See Also

- pm-1password
- pm-bitwarden
- pm-generic
