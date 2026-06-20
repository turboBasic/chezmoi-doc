---
id: pm-bitwarden
title: Using Bitwarden with chezmoi
category: password-managers
tags: [password-manager, template, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/password-managers/bitwarden.md
related: [pm-overview, pm-generic]
---

## Summary

chezmoi integrates with Bitwarden through three CLI tools: the official Bitwarden CLI (`bw`), the Bitwarden Secrets CLI (`bws`), and the unofficial `rbw` client. Template functions retrieve items, custom fields, attachments, and secrets manager entries.

## Syntax / Usage

```text
{{ (bitwarden "item" "$NAME_OR_ID").login.username }}
{{ (bitwardenFields "item" "$NAME_OR_ID").fieldname.value }}
{{ bitwardenAttachment "$FILENAME" "$ITEMID" }}
{{ bitwardenAttachmentByRef "$FILENAME" "item" "$NAME" }}
{{ (bitwardenSecrets "$SECRET_ID" ["$ACCESS_TOKEN"]).value }}
{{ (rbw "$NAME" ["--folder" "$FOLDER"]).data.password }}
{{ (rbwFields "$NAME").fieldname.value }}
```

## Details

**Bitwarden CLI (`bw`) functions:**

| Function | Invokes | Returns |
| --- | --- | --- |
| `bitwarden` | `bw get $ARGS` | Full item as parsed JSON |
| `bitwardenFields` | `bw get $ARGS` | Map of custom `fields` indexed by field `name` |
| `bitwardenAttachment` | `bw get attachment $FILENAME --itemid $ITEMID` | Raw attachment content |
| `bitwardenAttachmentByRef` | `bw get $ARGS` then `bw get attachment` | Raw attachment content (resolves item ID from name) |

**Bitwarden Secrets CLI (`bws`) functions:**

| Function | Invokes | Returns |
| --- | --- | --- |
| `bitwardenSecrets` | `bws secret get $SECRET_ID` | Parsed JSON secret object |

**rbw functions:**

| Function | Invokes | Returns |
| --- | --- | --- |
| `rbw` | `rbw get --raw $NAME $ARGS` | Full item as parsed JSON |
| `rbwFields` | `rbw get --raw $NAME $ARGS` | Map of `fields` indexed by field `name` |

**Authentication (Bitwarden CLI):**

1. Log in: `bw login $EMAIL`, `bw login --apikey`, or `bw login --sso`
2. Unlock: `export BW_SESSION=$(bw unlock --raw)`

**Automatic unlock** (set in config):

```toml
[bitwarden]
    unlock = "auto"
```

| Value | Effect |
| --- | --- |
| `false` | Never auto-unlock |
| `true` | Always run `bw unlock --raw` automatically |
| `"auto"` | Only unlock if `BW_SESSION` is not set |

When chezmoi auto-unlocks, it also runs `bw lock` before terminating.

**Bitwarden Secrets CLI authentication:**

Set `BWS_ACCESS_TOKEN` environment variable or pass the access token as the second argument to `bitwardenSecrets`.

**Caching:** All function outputs are cached per unique set of arguments within a single chezmoi invocation.

## Examples

Retrieve login credentials:

```text
username = {{ (bitwarden "item" "example.com").login.username }}
password = {{ (bitwarden "item" "example.com").login.password }}
```

Retrieve a custom field:

```text
{{ (bitwardenFields "item" "example.com").token.value }}
```

Retrieve an attachment by item ID:

```text
{{ bitwardenAttachment "id_rsa" "bf22e4b4-ae4a-4d1c-8c98-ac620004b628" }}
```

Retrieve an attachment by item name:

```text
{{ bitwardenAttachmentByRef "id_rsa" "item" "example.com" }}
```

Retrieve a secret from Bitwarden Secrets Manager:

```text
{{ (bitwardenSecrets "be8e0ad8-d545-4017-a55a-b02f014d4158").value }}
```

Using rbw:

```text
username = {{ (rbw "test-entry").data.username }}
password = {{ (rbw "test-entry" "--folder" "my-folder").data.password }}
```

Using rbwFields for custom fields:

```text
{{ (rbwFields "item" "--folder" "my-folder").name.value }}
```

Config for automatic unlock:

```toml
[bitwarden]
    unlock = "auto"
```

## Caveats / Common Mistakes

- `BW_SESSION` must be set before running chezmoi unless `bitwarden.unlock` is configured.
- API key and SSO logins always require an explicit `bw unlock` step after login.
- `bitwardenAttachmentByRef` makes two CLI calls (one to resolve the item ID, one to fetch the attachment).
- `rbw` is an unofficial alternative client; it is separate from the official Bitwarden CLI.

## See Also

- pm-overview
- pm-generic
