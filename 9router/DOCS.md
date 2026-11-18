# 9Router add-on

Runs the official `decolua/9router` image (same one you used on Debian/Pi).

## First start
1. Install, start. The default dashboard password is `123456` – change it right away (dashboard settings and/or the add-on option).
2. Open `http://<ha-ip>:20128/dashboard`, connect providers.
3. Point tools at `http://<ha-ip>:20128/v1` with an API key created in the dashboard.

## LAN access
Port 20128 is published on all host interfaces. Check Configuration → Network that the port isn't blank.
No ingress: the dashboard expects to be served from the root path. Don't forward this port to the internet.

## Options
| Option | Default | Notes |
|---|---|---|
| initial_password | 123456 | Initial dashboard login. Likely only applied on first run; change it in the dashboard too. **Weak default, and the port is open on your LAN.** |
| require_api_key | true | Require key on /v1 |
| enable_request_logs | false | Full bodies to disk – heavy and privacy-sensitive |
| base_url | empty | Set if you access it by hostname/tunnel |
| max_memory_mb | 256 | Node heap cap; raise to 384–512 if you see restarts |

## Data
SQLite DB and secrets live in `/data` (included in HA backups).

## Upgrading
Change the tag in `Dockerfile` and `version` in `config.yaml`, push, then Update in the add-on page.
