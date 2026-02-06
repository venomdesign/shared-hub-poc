#!/usr/bin/env bash
set -euo pipefail

echo "== Install Native Federation =="

npm i -D @angular-architects/native-federation

echo "== Add Native Federation to projects (non-interactive) =="

# Remotes:
ng add @angular-architects/native-federation --project mfe1 --port 4201 --type remote --skip-confirmation
ng add @angular-architects/native-federation --project mfe2 --port 4202 --type remote --skip-confirmation

# Host (dynamic-host so it uses a manifest)
ng add @angular-architects/native-federation --project shell --port 4200 --type dynamic-host --skip-confirmation

echo "== Force ports in angular.json (so ng serve uses correct ports) =="

node <<'NODE'
const fs = require('fs');
const p = 'angular.json';
const j = JSON.parse(fs.readFileSync(p,'utf8'));

function setPort(name, port) {
  const proj = j.projects?.[name];
  if (!proj?.architect?.serve) throw new Error('Missing serve target for ' + name);
  proj.architect.serve.options = proj.architect.serve.options || {};
  proj.architect.serve.options.port = port;
}
setPort('shell', 4200);
setPort('mfe1', 4201);
setPort('mfe2', 4202);

fs.writeFileSync(p, JSON.stringify(j,null,2));
console.log('✅ Ports fixed: shell 4200, mfe1 4201, mfe2 4202');
NODE

echo "== Ensure shell manifest points to remotes =="

# Native Federation host manifest is served from public/ in modern Angular
mkdir -p apps/shell/public

cat > apps/shell/public/federation.manifest.json <<'EOF'
{
  "mfe1": "http://localhost:4201/remoteEntry.json",
  "mfe2": "http://localhost:4202/remoteEntry.json"
}
EOF

echo "✅ Native Federation enabled + ports + manifest set."
