// Minimal launcher page for the HA sidebar (ingress). Tiny heap, no dependencies.
const http = require('http');
const html = `<!doctype html><meta charset="utf-8"><title>9Router</title>
<body style="font-family:sans-serif;background:#111;color:#eee;padding:2rem">
<p>Opening 9Router&hellip;</p>
<p><a id="l" target="_blank" style="color:#4fc3f7">Open in a new tab</a></p>
<script>
var u=location.protocol+'//'+location.hostname+':20128/dashboard';
document.getElementById('l').href=u;
if(location.protocol==='http:')location.replace(u);
</script>`;
http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(html);
}).listen(8099, '0.0.0.0');
