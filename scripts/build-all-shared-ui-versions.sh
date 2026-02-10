#!/usr/bin/env bash
set -euo pipefail

echo "== Building all shared-ui versions (v1, v2, v3) =="

# Safety check
if [ ! -f "libs/shared-ui/ng-package.json" ]; then
  echo "❌ libs/shared-ui/ng-package.json not found"
  exit 1
fi

mkdir -p artifacts

# -----------------------------
# Helper function
# -----------------------------
build_version () {
  VERSION="$1"

  echo "== Building shared-ui v$VERSION =="

  # 1) Update source package.json version
  node <<NODE
const fs = require('fs');

// Update package.json
const pkgPath = 'libs/shared-ui/package.json';
const pkg = JSON.parse(fs.readFileSync(pkgPath,'utf8'));
pkg.version = '$VERSION';
fs.writeFileSync(pkgPath, JSON.stringify(pkg,null,2));
console.log('✔ libs/shared-ui/package.json version set to $VERSION');

// Update version.ts to match package.json
const versionTsPath = 'libs/shared-ui/src/lib/version.ts';
const versionTs = \`// This file is updated by the build script
// Version is set from libs/shared-ui/package.json during build
export const SHARED_UI_VERSION = '$VERSION';
\`;
fs.writeFileSync(versionTsPath, versionTs);
console.log('✔ libs/shared-ui/src/lib/version.ts synced with package.json');
NODE

  # 2) Build library
  ng build shared-ui

  # 3) Pack
  pushd dist/shared-ui >/dev/null
  TARBALL=$(npm pack)
  popd >/dev/null

  mv "dist/shared-ui/$TARBALL" "artifacts/shared-ui-$VERSION.tgz"
  echo "✔ Packed artifacts/shared-ui-$VERSION.tgz"
}

# -----------------------------
# Build all versions
# -----------------------------
build_version "1.0.0"
build_version "2.0.0"
build_version "3.0.0"

# -----------------------------
# Register aliases
# -----------------------------
echo "== Register npm aliases =="

node <<'NODE'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json','utf8'));

pkg.dependencies ||= {};
pkg.dependencies['shared-ui-v1'] = 'file:artifacts/shared-ui-1.0.0.tgz';
pkg.dependencies['shared-ui-v2'] = 'file:artifacts/shared-ui-2.0.0.tgz';
pkg.dependencies['shared-ui-v3'] = 'file:artifacts/shared-ui-3.0.0.tgz';

fs.writeFileSync('package.json', JSON.stringify(pkg,null,2));
console.log('✔ npm aliases registered');
NODE

npm install --legacy-peer-deps

echo "✅ Shared UI v1/v2/v3 built and installed correctly"
