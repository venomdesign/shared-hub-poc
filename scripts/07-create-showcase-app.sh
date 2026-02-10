#!/usr/bin/env bash
set -euo pipefail

echo "== Creating Showcase Application =="

cd "$(dirname "$0")/.."

# Create showcase app directory structure manually
echo "Step 1: Creating showcase app structure..."
mkdir -p apps/showcase/src/app
mkdir -p apps/showcase/public

# Create tsconfig files
echo "Step 2: Creating TypeScript configuration..."

cat > apps/showcase/tsconfig.app.json <<'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "../../out-tsc/app",
    "types": [],
    "paths": {
      "shared-ui": ["../../libs/shared-ui/src/public-api.ts"]
    }
  },
  "files": [
    "src/main.ts"
  ],
  "include": [
    "src/**/*.d.ts"
  ]
}
EOF

cat > apps/showcase/tsconfig.spec.json <<'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "../../out-tsc/spec",
    "types": [
      "jasmine"
    ],
    "paths": {
      "shared-ui": ["../../libs/shared-ui/src/public-api.ts"]
    }
  },
  "include": [
    "src/**/*.spec.ts",
    "src/**/*.d.ts"
  ]
}
EOF

# Create public files
echo "Step 3: Creating public assets..."
cp apps/shell/public/favicon.ico apps/showcase/public/

# Create source files
echo "Step 4: Creating application files..."

cat > apps/showcase/src/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Shared UI Showcase</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
  <app-root></app-root>
</body>
</html>
EOF

cat > apps/showcase/src/styles.scss <<'EOF'
/* You can add global styles to this file, and also import other style files */
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}

.component-demo {
  border: 1px solid #dee2e6;
  border-radius: 0.375rem;
  padding: 2rem;
  margin-bottom: 2rem;
  background-color: #f8f9fa;
}

.code-block {
  background-color: #282c34;
  color: #abb2bf;
  padding: 1rem;
  border-radius: 0.375rem;
  overflow-x: auto;
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
}
EOF

cat > apps/showcase/src/main.ts <<'EOF'
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig)
  .catch((err) => console.error(err));
EOF

cat > apps/showcase/src/app/app.config.ts <<'EOF'
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes)
  ]
};
EOF

cat > apps/showcase/src/app/app.routes.ts <<'EOF'
import { Routes } from '@angular/router';

export const routes: Routes = [];
EOF

cat > apps/showcase/src/app/app.ts <<'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';
import { UiBadgeComponent } from 'shared-ui';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule, UiBadgeComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  title = 'Shared UI Showcase';
}
EOF

cat > apps/showcase/src/app/app.html <<'EOF'
<div class="container-fluid">
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container-fluid">
      <span class="navbar-brand mb-0 h1">
        <i class="bi bi-palette-fill"></i> Shared UI Component Showcase
      </span>
      <div class="d-flex">
        <shared-ui-badge label="Live Demo"></shared-ui-badge>
      </div>
    </div>
  </nav>

  <div class="container">
    <div class="row">
      <div class="col-12">
        <div class="alert alert-info" role="alert">
          <h4 class="alert-heading">
            <i class="bi bi-info-circle-fill"></i> Hot-Wired Component Library
          </h4>
          <p class="mb-0">
            This showcase application imports components directly from <code>libs/shared-ui/src</code>.
            Any changes you make to components will be reflected immediately without rebuilding!
          </p>
        </div>
      </div>
    </div>

    <!-- Badge Component Demo -->
    <div class="row mt-4">
      <div class="col-12">
        <h2><i class="bi bi-tag-fill"></i> Badge Component</h2>
        <p class="text-muted">A version-aware badge component with automatic color coding</p>
      </div>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="component-demo">
          <h5>Default Badge</h5>
          <shared-ui-badge></shared-ui-badge>
        </div>
      </div>
      <div class="col-md-6">
        <div class="component-demo">
          <h5>Custom Label</h5>
          <shared-ui-badge label="Showcase"></shared-ui-badge>
        </div>
      </div>
    </div>

    <div class="row mt-3">
      <div class="col-12">
        <h5>Usage Example</h5>
        <div class="code-block">
<shared-ui-badge label="My App"></shared-ui-badge>
        </div>
      </div>
    </div>

    <div class="row mt-3">
      <div class="col-12">
        <h5>TypeScript Import</h5>
        <div class="code-block">
import { UiBadgeComponent } from 'shared-ui';

&#64;Component({
  imports: [UiBadgeComponent],
  template: `<shared-ui-badge label="Example"></shared-ui-badge>`
})
export class MyComponent {}
        </div>
      </div>
    </div>

    <!-- Features Section -->
    <div class="row mt-5">
      <div class="col-12">
        <h2><i class="bi bi-star-fill"></i> Features</h2>
      </div>
    </div>

    <div class="row mt-3">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title"><i class="bi bi-lightning-charge-fill text-warning"></i> Hot Reload</h5>
            <p class="card-text">
              Edit components in <code>libs/shared-ui</code> and see changes instantly without rebuilding.
            </p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title"><i class="bi bi-palette-fill text-primary"></i> Live Examples</h5>
            <p class="card-text">
              See components in action with real-time updates as you develop.
            </p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title"><i class="bi bi-book-fill text-success"></i> Documentation</h5>
            <p class="card-text">
              View API docs at <a href="http://localhost:8080" target="_blank">localhost:8080</a>
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Instructions -->
    <div class="row mt-5 mb-5">
      <div class="col-12">
        <div class="card bg-light">
          <div class="card-body">
            <h5 class="card-title"><i class="bi bi-gear-fill"></i> Development Workflow</h5>
            <ol>
              <li>Edit components in <code>libs/shared-ui/src/lib/</code></li>
              <li>Save your changes</li>
              <li>See updates immediately in this showcase (no rebuild needed!)</li>
              <li>Check API docs at <a href="http://localhost:8080" target="_blank">http://localhost:8080</a></li>
            </ol>
            <p class="mb-0 text-muted">
              <strong>Tip:</strong> Keep this showcase running while developing components for instant feedback!
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<router-outlet />
EOF

cat > apps/showcase/src/app/app.scss <<'EOF'
// Component-specific styles
EOF

# Update angular.json
echo "Step 5: Updating angular.json..."
node <<'NODE'
const fs = require('fs');
const angular = JSON.parse(fs.readFileSync('angular.json', 'utf8'));

angular.projects.showcase = {
  "projectType": "application",
  "schematics": {
    "@schematics/angular:component": {
      "style": "scss"
    }
  },
  "root": "apps/showcase",
  "sourceRoot": "apps/showcase/src",
  "prefix": "app",
  "architect": {
    "build": {
      "builder": "@angular-devkit/build-angular:application",
      "options": {
        "outputPath": "dist/showcase",
        "index": "apps/showcase/src/index.html",
        "browser": "apps/showcase/src/main.ts",
        "polyfills": [
          "zone.js"
        ],
        "tsConfig": "apps/showcase/tsconfig.app.json",
        "inlineStyleLanguage": "scss",
        "assets": [
          {
            "glob": "**/*",
            "input": "apps/showcase/public"
          }
        ],
        "styles": [
          "apps/showcase/src/styles.scss"
        ],
        "scripts": []
      },
      "configurations": {
        "production": {
          "budgets": [
            {
              "type": "initial",
              "maximumWarning": "500kB",
              "maximumError": "1MB"
            },
            {
              "type": "anyComponentStyle",
              "maximumWarning": "2kB",
              "maximumError": "4kB"
            }
          ],
          "outputHashing": "all"
        },
        "development": {
          "optimization": false,
          "extractLicenses": false,
          "sourceMap": true
        }
      },
      "defaultConfiguration": "production"
    },
    "serve": {
      "builder": "@angular-devkit/build-angular:dev-server",
      "configurations": {
        "production": {
          "buildTarget": "showcase:build:production"
        },
        "development": {
          "buildTarget": "showcase:build:development"
        }
      },
      "defaultConfiguration": "development",
      "options": {
        "port": 4300
      }
    },
    "extract-i18n": {
      "builder": "@angular-devkit/build-angular:extract-i18n"
    }
  }
};

fs.writeFileSync('angular.json', JSON.stringify(angular, null, 2));
console.log('✅ angular.json updated with showcase project');
NODE

# Update package.json with serve script
echo "Step 6: Adding npm script..."
node <<'NODE'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.scripts['serve:showcase'] = 'ng serve showcase --port 4300';

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Added serve:showcase script to package.json');
NODE

echo ""
echo "=========================================="
echo "✅ Showcase Application Created!"
echo "=========================================="
echo ""
echo "The showcase app is configured to import directly from libs/shared-ui/src"
echo "This means changes to components will be reflected immediately!"
echo ""
echo "To run the showcase:"
echo "  npm run serve:showcase"
echo ""
echo "Access at: http://localhost:4300"
echo ""
echo "Features:"
echo "  ✅ Hot-wired to libs/shared-ui source"
echo "  ✅ No rebuild needed for component changes"
echo "  ✅ Live component demos"
echo "  ✅ Bootstrap 5 styling"
echo "  ✅ Runs on port 4300"
echo ""
