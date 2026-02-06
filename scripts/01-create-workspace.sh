#!/usr/bin/env bash
set -euo pipefail

# Run from the empty shared-hub-poc folder you created.
# Creates Angular workspace IN PLACE (.) and puts projects under apps/ by default.

echo "== Angular workspace (in-place) =="

ng new . \
  --name=shared-hub-poc \
  --create-application=false \
  --package-manager=npm \
  --routing \
  --style=scss \
  --new-project-root=apps \
  --interactive=false \
  --defaults

mkdir -p scripts artifacts apps libs

echo "✅ Workspace created."
