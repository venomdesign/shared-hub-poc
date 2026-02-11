# Admin Override Feature - Complete Guide

## Overview

The shell application has the ability to **force all microfrontends to use a specific version** of the shared-ui library, regardless of their individual preferences. This is critical for:

- **Security patches** - Deploy fixes immediately across all MFEs
- **Critical bug fixes** - Instant rollout without waiting for MFE teams
- **Breaking changes** - Coordinate major version upgrades
- **Consistency** - Ensure uniform behavior across the platform

## Quick Start

### Enable V3 Override (Force All MFEs to Use V3)

```bash
# 1. Enable the override
npm run override:enable

# 2. Restart all applications
npm run serve:shell   # Terminal 1
npm run serve:mfe1    # Terminal 2
npm run serve:mfe2    # Terminal 3

# 3. Verify in browser (http://localhost:4200)
# Expected: All MFEs show RED badges (v3.0.0)
```

### Disable Override (Restore Version Independence)

```bash
# 1. Disable the override
npm run override:disable

# 2. Restart all applications
npm run serve:shell   # Terminal 1
npm run serve:mfe1    # Terminal 2
npm run serve:mfe2    # Terminal 3

# 3. Verify in browser (http://localhost:4200)
# Expected: MFE1 shows BLUE badge (v1.0.0), MFE2 shows GREEN badge (v2.0.0)
```

### Check Current Status

```bash
npm run override:status

# Output when override is ENABLED:
# ├── shared-ui-v1@npm:shared-ui@3.0.0 ✅
# ├── shared-ui-v2@npm:shared-ui@3.0.0 ✅
# └── shared-ui-v3@npm:shared-ui@3.0.0 ✅

# Output when override is DISABLED:
# ├── shared-ui-v1@npm:shared-ui@1.0.0 ✅
# ├── shared-ui-v2@npm:shared-ui@2.0.0 ✅
# └── shared-ui-v3@npm:shared-ui@3.0.0 ✅
```

## How It Works

### The Problem

Native Federation cannot redirect package names at runtime. When MFE1 imports `shared-ui-v1`, it will always get whatever code is in the `shared-ui-v1` package.

### The Solution

We use **package alias redirection** at the npm install level:

```json
// package.json - Override ENABLED
{
  "shared-ui-v1": "file:artifacts/shared-ui-3.0.0.tgz",  // Points to v3
  "shared-ui-v2": "file:artifacts/shared-ui-3.0.0.tgz",  // Points to v3
  "shared-ui-v3": "file:artifacts/shared-ui-3.0.0.tgz"   // Points to v3
}
```

Now when MFE1 imports from `shared-ui-v1`, it gets the v3.0.0 code!

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Shell (Admin)                        │
│  Controls package.json aliases                          │
│  npm run override:enable → All point to v3             │
└─────────────────────────────────────────────────────────┘
                    │                │
        ┌───────────┘                └───────────┐
        │                                        │
┌───────▼────────┐                      ┌───────▼────────┐
│     MFE1       │                      │     MFE2       │
│                │                      │                │
│  import from   │                      │  import from   │
│  'shared-ui-v1'│                      │  'shared-ui-v2'│
│       ↓        │                      │       ↓        │
│  Gets v3 code  │                      │  Gets v3 code  │
│  🔴 Red Badge  │                      │  🔴 Red Badge  │
└────────────────┘                      └────────────────┘
```

## Available Commands

### `npm run override:enable`

**What it does:**
1. Updates package.json to redirect v1 and v2 to v3 artifacts
2. Runs `npm install` to update node_modules
3. Displays instructions for restarting apps

**When to use:**
- Security vulnerability discovered in v1 or v2
- Critical bug fix in v3 needs immediate deployment
- Coordinating a major version upgrade

**Example output:**
```
Enabling V3 Override...

V3 override ENABLED
Package aliases updated:
   shared-ui-v1 → artifacts/shared-ui-3.0.0.tgz
   shared-ui-v2 → artifacts/shared-ui-3.0.0.tgz
   shared-ui-v3 → artifacts/shared-ui-3.0.0.tgz

Running npm install...
After install completes, restart all apps
Expected result: All MFEs will show RED badges (v3.0.0)
```

### `npm run override:disable`

**What it does:**
1. Restores package.json to original artifact paths
2. Runs `npm install` to update node_modules
3. Displays instructions for restarting apps

**When to use:**
- Override no longer needed
- Want to restore version independence
- Testing version coexistence

**Example output:**
```
Disabling V3 Override...

V3 override DISABLED
Package aliases restored:
   shared-ui-v1 → artifacts/shared-ui-1.0.0.tgz
   shared-ui-v2 → artifacts/shared-ui-2.0.0.tgz
   shared-ui-v3 → artifacts/shared-ui-3.0.0.tgz

Running npm install...
After install completes, restart all apps
Expected result:
   - MFE1 will show BLUE badge (v1.0.0)
   - MFE2 will show GREEN badge (v2.0.0)
```

### `npm run override:status`

**What it does:**
- Shows which version each package alias resolves to
- Quick way to verify current override state

**Example output:**
```
├── shared-ui-v1@npm:shared-ui@3.0.0  ← Override active
├── shared-ui-v2@npm:shared-ui@3.0.0  ← Override active
└── shared-ui-v3@npm:shared-ui@3.0.0
```

## Real-World Scenarios

### Scenario 1: Emergency Security Patch

**Situation:** CVE discovered in shared-ui v1.0.0 and v2.0.0

**Action:**
```bash
# 1. Enable override to force v3 (patched version)
npm run override:enable

# 2. Restart all apps
npm run serve:shell &
npm run serve:mfe1 &
npm run serve:mfe2 &

# 3. Verify all MFEs show v3 (red badges)
# 4. Monitor for issues

# 5. Once MFE teams update their code, disable override
npm run override:disable
```

**Result:**
- Instant security patch across entire platform
- No MFE code changes required
- Single command deployment

### Scenario 2: Critical Bug Fix

**Situation:** Production bug in v1 and v2, fixed in v3

**Action:**
```bash
# Enable override immediately
npm run override:enable

# Restart production apps
# All users now get v3 with bug fix
```

### Scenario 3: Coordinated Upgrade

**Situation:** Breaking changes in v3, need to coordinate upgrade

**Action:**
```bash
# Phase 1: Test with override in staging
npm run override:enable
# Test thoroughly

# Phase 2: Enable in production
npm run override:enable
# Monitor for issues

# Phase 3: MFE teams update their code to use v3 directly
# Once all teams updated, disable override
npm run override:disable
```

## Testing

### Test Override Enabled

```bash
# 1. Enable override
npm run override:enable

# 2. Check status
npm run override:status
# Should show all packages at v3.0.0

# 3. Start apps
npm run serve:shell   # Terminal 1
npm run serve:mfe1    # Terminal 2
npm run serve:mfe2    # Terminal 3

# 4. Open browser: http://localhost:4200

# 5. Navigate to MFE1
# Expected: RED badge with "Shared UI v3.0.0"

# 6. Navigate to MFE2
# Expected: RED badge with "Shared UI v3.0.0"

# 7. Check browser console
console.log('MFE1 version:', 
  document.querySelector('shared-ui-badge').textContent);
// Output: "Shared UI v3.0.0"
```

### Test Override Disabled

```bash
# 1. Disable override
npm run override:disable

# 2. Check status
npm run override:status
# Should show v1 at 1.0.0, v2 at 2.0.0, v3 at 3.0.0

# 3. Restart apps
npm run serve:shell   # Terminal 1
npm run serve:mfe1    # Terminal 2
npm run serve:mfe2    # Terminal 3

# 4. Open browser: http://localhost:4200

# 5. Navigate to MFE1
# Expected: BLUE badge with "Shared UI v1.0.0"

# 6. Navigate to MFE2
# Expected: GREEN badge with "Shared UI v2.0.0"
```

## Important Notes

### Restart Required

After enabling or disabling the override, you **MUST restart all applications**:
- Shell
- MFE1
- MFE2

The override only takes effect after:
1. `npm install` completes (updates node_modules)
2. Applications are restarted (reload new modules)

### Not Runtime-Toggleable

This is a **deployment-time configuration**, not a runtime toggle. You cannot switch between override enabled/disabled without:
1. Running the script
2. Running npm install
3. Restarting all apps

### Production Deployment

For production, you would:
1. Run `npm run override:enable` on your build server
2. Build all applications
3. Deploy the built artifacts
4. Restart services

## Troubleshooting

### Problem: Badges still showing wrong colors after enabling override

**Solution:**
```bash
# 1. Verify override is enabled
npm run override:status
# All should show v3.0.0

# 2. If not, run enable again
npm run override:enable

# 3. IMPORTANT: Restart ALL apps
# Kill all running terminals and restart:
npm run serve:shell
npm run serve:mfe1
npm run serve:mfe2

# 4. Hard refresh browser (Ctrl+Shift+R)
```

### Problem: npm install fails

**Solution:**
```bash
# 1. Check artifacts exist
dir artifacts
# Should see: shared-ui-1.0.0.tgz, shared-ui-2.0.0.tgz, shared-ui-3.0.0.tgz

# 2. If missing, rebuild them
npm run build:shared-ui-versions

# 3. Try again
npm run override:enable
```

### Problem: Want to verify which code is actually loaded

**Solution:**
```bash
# Check the actual package contents
npm list shared-ui-v1 shared-ui-v2 shared-ui-v3

# Or check in browser console
import('shared-ui-v1').then(m => console.log('v1 version:', m.SHARED_UI_VERSION));
import('shared-ui-v2').then(m => console.log('v2 version:', m.SHARED_UI_VERSION));
import('shared-ui-v3').then(m => console.log('v3 version:', m.SHARED_UI_VERSION));
```

## Summary

### What You Can Do

- **Force all MFEs to use v3** with one command
- **Restore version independence** with one command
- **Check current status** anytime
- **No MFE code changes required**
- **Instant deployment** (after restart)

### What You Cannot Do

- Toggle at runtime without restart
- Override individual MFEs (it's all or nothing)
- Use different override versions for different MFEs

### Current Status

Run `npm run override:status` to see current state.

**Override ENABLED:**
- All MFEs use v3 (red badges)
- Package aliases point to v3 artifact

**Override DISABLED:**
- MFEs use their preferred versions
- MFE1 uses v1 (blue badge)
- MFE2 uses v2 (green badge)

---

For more technical details, see:
- `ADMIN_OVERRIDE_SOLUTION.md` - Technical implementation details
- `VERSION_MANAGEMENT.md` - Version management architecture
- `CENTRAL_DEPENDENCY_MANAGEMENT.md` - Dependency management strategy
