#!/usr/bin/env bash
set -euo pipefail

echo "== Create Fumadocs app (scripted, no prompts) =="

npm i -D create-fumadocs-app

node <<'NODE'
import { create } from 'create-fumadocs-app';

await create({
  outputDir: 'apps/shared-ui-demo',
  template: '+next+fuma-docs-mdx',
  packageManager: 'npm',
});
NODE

echo "== Force dev port 4300 =="

node <<'NODE'
import fs from 'node:fs';

const pkgPath = 'apps/shared-ui-demo/package.json';
const pkg = JSON.parse(fs.readFileSync(pkgPath,'utf8'));

pkg.scripts = pkg.scripts || {};
// Most templates use next dev; we force port 4300.
pkg.scripts.dev = "next dev -p 4300";
fs.writeFileSync(pkgPath, JSON.stringify(pkg,null,2));
console.log('✅ apps/shared-ui-demo dev port set to 4300');
NODE

echo "== Install docs deps =="
cd apps/shared-ui-demo
npm install

echo "✅ Fumadocs demo ready at apps/shared-ui-demo (port 4300)."
echo "Run: cd apps/shared-ui-demo && npm run dev"
