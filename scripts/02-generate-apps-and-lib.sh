#!/usr/bin/env bash
set -euo pipefail

echo "== Generate Angular apps (standalone, external template/style) =="

ng g application shell --standalone --routing --style=scss --skip-tests --ssr=false
ng g application mfe1  --standalone --routing --style=scss --skip-tests --ssr=false
ng g application mfe2  --standalone --routing --style=scss --skip-tests --ssr=false

echo "== Generate shared-ui library into libs/shared-ui =="

ng g library shared-ui --standalone --style=scss --skip-tests --project-root=libs/shared-ui

echo "== Ensure folders exist =="
mkdir -p artifacts

echo "✅ Apps + library generated."
