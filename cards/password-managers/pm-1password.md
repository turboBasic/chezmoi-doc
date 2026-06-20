---
id: pm-1password
title: Using 1Password with chezmoi
category: password-managers
tags: [password-manager, template, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/password-managers/1password.md
related: [pm-overview, pm-generic]
---

## Summary

chezmoi integrates with 1Password through the `op` CLI, providing five template functions to retrieve items, documents, fields, and secret references. It supports interactive sign-in prompts, biometric authentication, 1Password Connect, and Service Accounts.

## Syntax / Usage

```text
{{ onepasswordRead "op://vault/item/field" [account] }}
{{ onepassword "UUID" [vault [account]] }}
{{ onepasswordDetailsFields "UUID" [vault [account]] }}
{{ onepasswordDocument "UUID" [vault [account]] }}
{{ onepasswordItemFields "UUID" [vault [account]] }}
```

## Details

**Functions:**

| Function | Invokes | Returns |
| --- | --- | --- |
| `onepasswordRead` | `op read --no-newline $URL` | Raw secret value as string |
| `onepassword` | `op item get $UUID --format json` | Full item as parsed JSON struct |
| `onepasswordDetailsFields` | `op item get $UUID --format json` | Map of fields indexed by `id` or `label` |
| `onepasswordDocument` | `op get document $UUID` | Raw document content |
| `onepasswordItemFields` | `op item get $UUID --format json` | Map of section fields indexed by field `label` |

**Authentication:**

- With biometric authentication, no manual sign-in is needed.
- Without biometrics, sign in with `eval $(op signin --account $SUBDOMAIN)`.
- If no valid session exists, chezmoi interactively prompts to sign in (default behavior).
- Set `onepassword.prompt = false` to disable interactive prompts and fail with an error instead.

**Modes** (set via `onepassword.mode` in config):

| Mode | Description | Restrictions |
| --- | --- | --- |
| `account` (default) | Normal CLI usage | Errors if `OP_SERVICE_ACCOUNT_TOKEN` or both Connect env vars are set |
| `connect` | 1Password Connect server | No `onepasswordDocument`; no `account` parameter; requires `OP_CONNECT_HOST` + `OP_CONNECT_TOKEN` |
| `service` | Service Account token | No `account` parameter; requires `OP_SERVICE_ACCOUNT_TOKEN` |

**Configuration:**

```toml
[onepassword]
    mode = "account"  # "account", "connect", or "service"
    prompt = true      # interactive sign-in prompt
```

The CLI command can be overridden with `onePassword.command` and extra arguments added with `onePassword.args`.

**Account resolution with biometrics:** chezmoi derives valid account identifiers from `op account list`. Valid values include: account-uuid, user-uuid, URL (with or without domain suffix), email, email-prefix, or email@short-url.

**Caching:** All function outputs are cached per unique set of arguments within a single chezmoi invocation.

**Performance:** Supplying the optional `vault` parameter significantly improves lookup performance.

## Examples

Retrieve a secret using a secret reference URL:

```text
{{ onepasswordRead "op://app-prod/db/password" }}
```

Retrieve a password from a specific vault and account:

```text
{{ (onepasswordDetailsFields "$UUID" "$VAULT_UUID" "my@account1").password.value }}
```

Retrieve a document (e.g., SSH key):

```text
{{- onepasswordDocument "$UUID" -}}
```

Iterate fields to find a password:

```text
{{ range (onepassword "$UUID").fields -}}
{{   if and (eq .label "password") (eq .purpose "PASSWORD") -}}
{{     .value -}}
{{   end -}}
{{ end }}
```

Access item fields by label:

```text
{{ (onepasswordItemFields "$UUID").exampleLabel.value }}
```

## Caveats / Common Mistakes

- Do not use `prompt = true` on shared machines: the session token is passed via command-line arguments visible to other users.
- In `connect` mode, `onepasswordDocument` is unavailable.
- In `connect` and `service` modes, the `account` parameter must not be used.
- 1Password Connect and Service Accounts do not support multiple accounts.
- If multiple 1Password accounts share an identifier (e.g., same URL), that identifier is removed from the lookup map and cannot be used for resolution.

## See Also

- pm-overview
- pm-generic
