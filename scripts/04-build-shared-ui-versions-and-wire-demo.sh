#!/usr/bin/env bash
set -euo pipefail

echo "== Install Bootstrap (no Material) =="
npm i bootstrap

echo "== Add bootstrap to angular.json styles for shell/mfe1/mfe2 =="
node <<'NODE'
const fs = require('fs');
const p='angular.json';
const j=JSON.parse(fs.readFileSync(p,'utf8'));

function addStyles(name){
  const build=j.projects?.[name]?.architect?.build;
  if(!build?.options) throw new Error('Missing build options for '+name);
  build.options.styles = build.options.styles || [];
  const s = build.options.styles;
  const bootstrap="node_modules/bootstrap/dist/css/bootstrap.min.css";
  if(!s.includes(bootstrap)) s.unshift(bootstrap);
}
['shell','mfe1','mfe2'].forEach(addStyles);

fs.writeFileSync(p, JSON.stringify(j,null,2));
console.log('✅ bootstrap css added to styles');
NODE

echo "== Create shared-ui library source (Badge) =="

mkdir -p libs/shared-ui/src/lib/badge

cat > libs/shared-ui/src/lib/version.ts <<'EOF'
export const SHARED_UI_VERSION = '0.0.0';
EOF

cat > libs/shared-ui/src/lib/badge/ui-badge.component.ts <<'EOF'
import { Component, Input } from '@angular/core';
import { SHARED_UI_VERSION } from '../version';

@Component({
  selector: 'shared-ui-badge',
  standalone: true,
  templateUrl: './ui-badge.component.html',
  styleUrls: ['./ui-badge.component.scss'],
})
export class UiBadgeComponent {
  @Input() label = 'UI Kit';
  version = SHARED_UI_VERSION;
}
EOF

cat > libs/shared-ui/src/lib/badge/ui-badge.component.html <<'EOF'
<span class="badge text-bg-primary">
  {{ label }} v{{ version }}
</span>
EOF

cat > libs/shared-ui/src/lib/badge/ui-badge.component.scss <<'EOF'
:host { display: inline-block; }
EOF

# Export from public API
cat > libs/shared-ui/src/public-api.ts <<'EOF'
export * from './lib/badge/ui-badge.component';
export * from './lib/version';
EOF

echo "== Helper: set shared-ui version constant and package version =="

node <<'NODE'
const fs = require('fs');

function setVersion(v){
  // set library version constant
  fs.writeFileSync('libs/shared-ui/src/lib/version.ts', `export const SHARED_UI_VERSION = '${v}';\n`);

  // set library package.json version (inside libs project)
  const libPkgPath = 'libs/shared-ui/package.json';
  const libPkg = JSON.parse(fs.readFileSync(libPkgPath,'utf8'));
  libPkg.version = v;
  fs.writeFileSync(libPkgPath, JSON.stringify(libPkg,null,2));
  console.log('✅ shared-ui set to version', v);
}

setVersion(process.argv[2]);
NODE

echo "== Build + pack shared-ui v1.0.0 =="

node -e "require('fs').writeFileSync('libs/shared-ui/src/lib/version.ts', \"export const SHARED_UI_VERSION = '1.0.0';\\n\")"
node -e "const fs=require('fs');const p='libs/shared-ui/package.json';const j=JSON.parse(fs.readFileSync(p,'utf8'));j.version='1.0.0';fs.writeFileSync(p,JSON.stringify(j,null,2));"

ng build shared-ui

pushd dist/shared-ui >/dev/null
TAR1=$(npm pack)
popd >/dev/null

mv "dist/shared-ui/$TAR1" "artifacts/shared-ui-1.0.0.tgz"

echo "== Build + pack shared-ui v2.0.0 =="

node -e "require('fs').writeFileSync('libs/shared-ui/src/lib/version.ts', \"export const SHARED_UI_VERSION = '2.0.0';\\n\")"
node -e "const fs=require('fs');const p='libs/shared-ui/package.json';const j=JSON.parse(fs.readFileSync(p,'utf8'));j.version='2.0.0';fs.writeFileSync(p,JSON.stringify(j,null,2));"

ng build shared-ui

pushd dist/shared-ui >/dev/null
TAR2=$(npm pack)
popd >/dev/null

mv "dist/shared-ui/$TAR2" "artifacts/shared-ui-2.0.0.tgz"

echo "== Add npm aliases (shared-ui-v1/shared-ui-v2) to root package.json =="

node <<'NODE'
const fs=require('fs');
const p='package.json';
const j=JSON.parse(fs.readFileSync(p,'utf8'));
j.dependencies = j.dependencies || {};
j.dependencies["shared-ui-v1"] = "file:artifacts/shared-ui-1.0.0.tgz";
j.dependencies["shared-ui-v2"] = "file:artifacts/shared-ui-2.0.0.tgz";
fs.writeFileSync(p, JSON.stringify(j,null,2));
console.log('✅ Added shared-ui-v1 and shared-ui-v2 aliases');
NODE

npm install

echo "== Create remote entry components in mfe1/mfe2 (default skew + override) =="

for APP in mfe1 mfe2; do
  mkdir -p "apps/$APP/src/app/remote-entry"

  cat > "apps/$APP/src/app/remote-entry/remote-entry.component.ts" <<EOF
import { Component, computed, inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { UiBadgeComponent as UiBadgeV1 } from 'shared-ui-v1';
import { UiBadgeComponent as UiBadgeV2 } from 'shared-ui-v2';

@Component({
  selector: '${APP}-remote-entry',
  standalone: true,
  imports: [UiBadgeV1, UiBadgeV2],
  templateUrl: './remote-entry.component.html',
  styleUrls: ['./remote-entry.component.scss'],
})
export class RemoteEntryComponent {
  private route = inject(ActivatedRoute);

  // default: mfe1 => v1, mfe2 => v2
  private defaultUi = '${APP}' === 'mfe1' ? 'v1' : 'v2';

  ui = computed(() => {
    const qp = this.route.snapshot.queryParamMap.get('ui');
    if (qp === 'latest') return 'v2';
    return this.defaultUi;
  });
}
EOF

  cat > "apps/$APP/src/app/remote-entry/remote-entry.component.html" <<EOF
<div class="container py-3">
  <div class="d-flex align-items-center gap-2 mb-3">
    <h3 class="mb-0">${APP.toUpperCase()}</h3>
    <ng-container *ngIf="ui() === 'v1'; else v2">
      <shared-ui-badge [label]="'Shared UI'"></shared-ui-badge>
      <span class="text-muted">(default)</span>
    </ng-container>
    <ng-template #v2>
      <shared-ui-badge [label]="'Shared UI'"></shared-ui-badge>
      <span class="text-muted">(latest override)</span>
    </ng-template>
  </div>

  <div class="alert alert-secondary">
    Query param <code>?ui=latest</code> forces the latest UI kit.
  </div>
</div>
EOF

  cat > "apps/$APP/src/app/remote-entry/remote-entry.component.scss" <<'EOF'
:host { display:block; }
EOF
done

echo "== Native Federation config: expose RemoteEntryComponent from each remote =="

# Overwrite the federation config created by ng add to expose our component.
# Per the Angular Blog post, this file is federation.config.js. :contentReference[oaicite:3]{index=3}

cat > apps/mfe1/federation.config.js <<'EOF'
const { withNativeFederation, shareAll } = require('@angular-architects/native-federation/config');

module.exports = withNativeFederation({
  name: 'mfe1',
  exposes: {
    './Entry': './apps/mfe1/src/app/remote-entry/remote-entry.component.ts',
  },
  shared: {
    ...shareAll({ singleton: true, strictVersion: false, requiredVersion: 'auto' }),
  },
  skip: [
    'rxjs/ajax',
    'rxjs/fetch',
    'rxjs/testing',
    'rxjs/webSocket',
  ],
});
EOF

cat > apps/mfe2/federation.config.js <<'EOF'
const { withNativeFederation, shareAll } = require('@angular-architects/native-federation/config');

module.exports = withNativeFederation({
  name: 'mfe2',
  exposes: {
    './Entry': './apps/mfe2/src/app/remote-entry/remote-entry.component.ts',
  },
  shared: {
    ...shareAll({ singleton: true, strictVersion: false, requiredVersion: 'auto' }),
  },
  skip: [
    'rxjs/ajax',
    'rxjs/fetch',
    'rxjs/testing',
    'rxjs/webSocket',
  ],
});
EOF

echo "== Shell: routes load remotes with loadRemoteModule (Native Federation) =="

cat > apps/shell/src/app/app.routes.ts <<'EOF'
import { Routes } from '@angular/router';
import { loadRemoteModule } from '@angular-architects/native-federation';

export const routes: Routes = [
  {
    path: 'mfe1',
    loadComponent: () =>
      loadRemoteModule('mfe1', './Entry').then((m) => m.RemoteEntryComponent),
  },
  {
    path: 'mfe2',
    loadComponent: () =>
      loadRemoteModule('mfe2', './Entry').then((m) => m.RemoteEntryComponent),
  },
  { path: '', pathMatch: 'full', redirectTo: 'mfe1' },
];
EOF

echo "== Shell: nav + override toggle (passes ui=latest) =="

cat > apps/shell/src/app/app.component.ts <<'EOF'
import { Component, computed, signal } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, RouterOutlet],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  forceLatest = signal(false);

  mfe1Link = computed(() => this.forceLatest() ? ['/mfe1'] : ['/mfe1']);
  mfe2Link = computed(() => this.forceLatest() ? ['/mfe2'] : ['/mfe2']);

  mfe1Query = computed(() => this.forceLatest() ? { ui: 'latest' } : {});
  mfe2Query = computed(() => this.forceLatest() ? { ui: 'latest' } : {});
}
EOF

cat > apps/shell/src/app/app.component.html <<'EOF'
<nav class="navbar navbar-expand navbar-dark bg-dark px-3">
  <a class="navbar-brand" routerLink="/">Shared Hub</a>

  <div class="navbar-nav me-auto">
    <a class="nav-link"
       [routerLink]="mfe1Link()"
       [queryParams]="mfe1Query()"
       routerLinkActive="active">MFE1</a>

    <a class="nav-link"
       [routerLink]="mfe2Link()"
       [queryParams]="mfe2Query()"
       routerLinkActive="active">MFE2</a>
  </div>

  <div class="d-flex align-items-center gap-2 text-white">
    <label class="form-check form-switch mb-0">
      <input class="form-check-input"
             type="checkbox"
             [checked]="forceLatest()"
             (change)="forceLatest.set(!forceLatest())">
      <span class="form-check-label">Force latest UI</span>
    </label>
  </div>
</nav>

<router-outlet></router-outlet>
EOF

cat > apps/shell/src/app/app.component.scss <<'EOF'
:host { display: block; }
EOF

echo "✅ shared-ui versions built + skew/override demo wired."
