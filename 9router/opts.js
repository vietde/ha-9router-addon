// Turns /data/options.json into shell assignments (no jq/bashio needed).
const fs = require('fs');
let o = {};
try { o = JSON.parse(fs.readFileSync('/data/options.json', 'utf8')); } catch (e) {}
const q = (v) => "'" + String(v ?? '').replace(/'/g, "'\\''") + "'";
console.log([
  `OPT_PASS=${q(o.initial_password)}`,
  `OPT_REQ=${q(o.require_api_key !== false)}`,
  `OPT_LOGS=${q(o.enable_request_logs === true)}`,
  `OPT_BASE=${q(o.base_url)}`,
  `OPT_MEM=${q(o.max_memory_mb || 256)}`,
].join('\n'));
