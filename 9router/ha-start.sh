#!/bin/sh
set -e

eval "$(node /opts.js)"

DATA=/data/9router
mkdir -p "$DATA"

# Persistent random secrets (generated once, kept across restarts)
gen() {
  [ -s "$1" ] || node -e "process.stdout.write(require('crypto').randomBytes(32).toString('hex'))" > "$1"
  cat "$1"
}
export JWT_SECRET="$(gen /data/jwt_secret)"
export API_KEY_SECRET="$(gen /data/api_key_secret)"

[ -z "$OPT_PASS" ] && OPT_PASS="123456"
export INITIAL_PASSWORD="$OPT_PASS"
export REQUIRE_API_KEY="$OPT_REQ"
export ENABLE_REQUEST_LOGS="$OPT_LOGS"

[ -z "$OPT_BASE" ] && OPT_BASE="http://localhost:20128"
export BASE_URL="$OPT_BASE" NEXT_PUBLIC_BASE_URL="$OPT_BASE"
export CLOUD_URL="https://9router.com" NEXT_PUBLIC_CLOUD_URL="https://9router.com"

export DATA_DIR="$DATA"
export PORT=20128
export HOSTNAME=0.0.0.0          # listen on all interfaces => reachable on LAN
export NODE_ENV=production
export NEXT_TELEMETRY_DISABLED=1
# Cap V8 heap so a Pi/HAOS box isn't starved
export NODE_OPTIONS="--max-old-space-size=${OPT_MEM}"

chown -R node:node "$DATA" 2>/dev/null || true

# Sidebar (ingress) launcher: a tiny static page served by busybox httpd (~1 MB RAM).
# It opens the real dashboard on port 20128 inside the HA frame.
mkdir -p /www
cat > /www/index.html <<'HTML'
<!doctype html><meta charset="utf-8"><title>9Router</title>
<body style="font-family:sans-serif;background:#111;color:#eee;padding:2rem">
<p>Opening 9Router&hellip;</p>
<p><a id="l" target="_blank" style="color:#4fc3f7">Open in a new tab</a></p>
<script>
var u=location.protocol+'//'+location.hostname+':20128/dashboard';
document.getElementById('l').href=u;
if(location.protocol==='http:')location.replace(u);
</script>
HTML
busybox httpd -p 8099 -h /www

cd /app
if [ -f custom-server.js ]; then ENTRY=custom-server.js; else ENTRY=server.js; fi
echo "[9router] Starting $ENTRY on :20128 (heap cap ${OPT_MEM} MB)"

# Reuse the image's own entrypoint (it drops privileges to the node user)
if [ -x /entrypoint.sh ]; then
  exec /entrypoint.sh node "$ENTRY"
fi
exec su-exec node node "$ENTRY"
