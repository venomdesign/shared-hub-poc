#!/usr/bin/env bash
set -euo pipefail

echo "== Creating Showcase App with Compodoc Integration =="

# 1. Generate showcase Angular app
echo "Step 1: Generating showcase Angular application..."
cd "$(dirname "$0")/.."

# Generate app without prompts
npx @angular/cli generate application showcase \
  --routing=true \
  --style=scss \
  --skip-tests=true \
  --standalone=true \
  --ssr=false \
  --skip-install=true

echo "✅ Showcase app generated"

# 2. Install Compodoc
echo "Step 2: Installing Compodoc..."
npm install --save-dev @compodoc/compodoc

echo "✅ Compodoc installed"

# 3. Create Compodoc configuration
echo "Step 3: Creating Compodoc configuration..."
cat > .compodocrc.json <<'EOF'
{
  "name": "Shared UI Component Library",
  "tsconfig": "libs/shared-ui/tsconfig.lib.json",
  "output": "docs/compodoc",
  "theme": "material",
  "includes": "libs/shared-ui/docs",
  "includesName": "Additional Documentation",
  "disableCoverage": false,
  "disablePrivate": false,
  "disableProtected": false,
  "disableInternal": false,
  "disableLifeCycleHooks": false,
  "disableRoutesGraph": true,
  "disableSearch": false,
  "disableDependencies": false,
  "disableSourceCode": false,
  "disableDomTree": false,
  "disableTemplateTab": false,
  "disableStyleTab": false,
  "disableGraph": false,
  "customFavicon": "",
  "gaID": "",
  "gaSite": "",
  "hideGenerator": false,
  "serve": true,
  "port": 8080,
  "watch": true,
  "exportFormat": "html",
  "language": "en-US"
}
EOF

echo "✅ Compodoc configuration created"

# 4. Add Compodoc scripts to package.json
echo "Step 4: Adding Compodoc scripts..."
node <<'NODE'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.scripts = pkg.scripts || {};
pkg.scripts['docs:generate'] = 'compodoc -p libs/shared-ui/tsconfig.lib.json';
pkg.scripts['docs:serve'] = 'compodoc -p libs/shared-ui/tsconfig.lib.json -s -w --port 8080';
pkg.scripts['docs:build'] = 'compodoc -p libs/shared-ui/tsconfig.lib.json -d docs/compodoc';
pkg.scripts['serve:showcase'] = 'ng serve showcase --port 4300';

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Compodoc scripts added to package.json');
NODE

# 5. Update angular.json for showcase app port
echo "Step 5: Configuring showcase app port to 4300..."
node <<'NODE'
const fs = require('fs');
const angular = JSON.parse(fs.readFileSync('angular.json', 'utf8'));

if (angular.projects.showcase && angular.projects.showcase.architect && angular.projects.showcase.architect.serve) {
  angular.projects.showcase.architect.serve.options = angular.projects.showcase.architect.serve.options || {};
  angular.projects.showcase.architect.serve.options.port = 4300;
  
  fs.writeFileSync('angular.json', JSON.stringify(angular, null, 2));
  console.log('✅ Showcase app port set to 4300');
} else {
  console.log('⚠️  Showcase app not found in angular.json - will configure manually');
}
NODE

# 6. Create documentation directory
echo "Step 6: Creating documentation directory..."
mkdir -p libs/shared-ui/docs
cat > libs/shared-ui/docs/getting-started.md <<'EOF'
# Getting Started

Welcome to the Shared UI Component Library documentation!

## Installation

```bash
npm install shared-ui-v1  # For version 1.0.0
npm install shared-ui-v2  # For version 2.0.0
npm install shared-ui-v3  # For version 3.0.0
```

## Quick Start

Import components from the library:

```typescript
import { UiBadgeComponent } from 'shared-ui-v1';
```

## Available Components

- **Badge Component**: Display version badges with color coding
- **Syncfusion Grid**: Data grid with paging, sorting, and filtering

## Live Examples

Visit the [Showcase App](http://localhost:4300) to see live component demos.
EOF

echo "✅ Documentation directory created"

echo ""
echo "=========================================="
echo "✅ Showcase App with Compodoc Setup Complete!"
echo "=========================================="
echo ""
echo "Available Commands:"
echo ""
echo "  npm run docs:generate    - Generate Compodoc documentation"
echo "  npm run docs:serve       - Serve Compodoc with live reload (port 8080)"
echo "  npm run docs:build       - Build Compodoc for production"
echo "  npm run serve:showcase   - Run showcase app (port 4300)"
echo ""
echo "Next Steps:"
echo "  1. Run: npm run docs:serve"
echo "     Opens Compodoc at http://localhost:8080"
echo ""
echo "  2. Run: npm run serve:showcase"
echo "     Opens showcase app at http://localhost:4300"
echo ""
echo "  3. Edit components in libs/shared-ui and see changes live!"
echo ""
