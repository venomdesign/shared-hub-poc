# Syncfusion License Setup for Micro-Frontend Architecture

## Overview
In a micro-frontend architecture with Native Federation, the Syncfusion license should be registered **once in the shell application** to apply to all micro-frontends.

## Why Register in Shell's bootstrap.ts?

### ❌ DON'T Register in main.ts
```typescript
// apps/shell/src/main.ts - DON'T DO THIS
import { initFederation } from '@angular-architects/native-federation';
import { registerLicense } from '@syncfusion/ej2-base';

registerLicense('YOUR_LICENSE_KEY'); // ❌ This will cause errors!

initFederation('federation.manifest.json')
  .catch(err => console.error(err))
  .then(_ => import('./bootstrap'))
  .catch(err => console.error(err));
```

**Problem**: main.ts runs BEFORE federation initialization, so Syncfusion packages aren't loaded yet, causing import errors.

### ✅ DO Register in bootstrap.ts
```typescript
// apps/shell/src/bootstrap.ts - CORRECT APPROACH
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import { registerLicense } from '@syncfusion/ej2-base';

// Register Syncfusion license key
registerLicense('YOUR_LICENSE_KEY');

bootstrapApplication(App, appConfig)
  .catch((err) => console.error(err));
```

**Why this works**:
1. main.ts initializes federation first
2. Federation loads and shares Syncfusion packages
3. bootstrap.ts runs AFTER federation is ready
4. License registration succeeds because packages are loaded

## Setup Instructions

### Step 1: Get Your License Key
1. Go to [Syncfusion License & Downloads](https://www.syncfusion.com/account/downloads)
2. Copy your license key

### Step 2: Register in Shell's bootstrap.ts
The license has already been added to `apps/shell/src/bootstrap.ts`. Just replace `'YOUR_LICENSE_KEY'` with your actual license key:

```typescript
registerLicense('YOUR_ACTUAL_LICENSE_KEY_HERE');
```

### Step 3: Verify Setup
1. Start the shell application:
   ```bash
   npm run serve:shell
   ```

2. Open the browser console at http://localhost:4200/
3. You should NOT see any Syncfusion license warnings

## Why Only in Shell?

In a Native Federation setup:
- **Shell controls shared dependencies** (see `apps/shell/federation.config.js`)
- All Syncfusion packages are marked as `singleton: true`
- MFEs use the shell's Syncfusion instances
- License registered in shell applies to all MFEs automatically

## Register ONLY in Shell

For this micro-frontend architecture where **MFEs are ONLY accessed through the shell**, you only need to register the license once:

- ✅ `apps/shell/src/bootstrap.ts` - Register license here ONLY
- ❌ `apps/mfe1/src/bootstrap.ts` - NOT needed
- ❌ `apps/mfe2/src/bootstrap.ts` - NOT needed

**Why Only in Shell?**
- All MFEs are loaded through the shell (they don't run standalone)
- Syncfusion packages are configured as `singleton: true` in the shell's federation config
- All MFEs use the shell's Syncfusion instances automatically
- The license registered in the shell applies to all MFEs that use Syncfusion components
- This includes MFE2 (which uses Syncfusion Grid) and any future MFEs that use Syncfusion

## Troubleshooting

### Error: "Cannot find module '@syncfusion/ej2-base'"
**Cause**: Trying to import in main.ts before federation initializes
**Solution**: Move the import to bootstrap.ts

### License Warning Still Appears
**Possible causes**:
1. License key is incorrect or expired
2. License key still says 'YOUR_LICENSE_KEY' (not replaced)
3. Browser cache - try hard refresh (Ctrl+Shift+R)

### License Works in Shell but Not in MFEs
**Check**:
1. Verify Syncfusion packages are in shell's federation.config.js shared section
2. Ensure `singleton: true` is set for Syncfusion packages
3. Check that MFEs are actually loading from shell (check Network tab)

## Environment Variables (Optional)

For better security, you can use environment variables:

1. Create `.env` file (add to .gitignore):
   ```
   SYNCFUSION_LICENSE_KEY=your_actual_key_here
   ```

2. Update bootstrap.ts:
   ```typescript
   import { environment } from './environments/environment';
   
   registerLicense(environment.syncfusionLicenseKey);
   ```

## Summary

✅ **Correct Setup**:
- Register license in `apps/shell/src/bootstrap.ts`
- Replace `'YOUR_LICENSE_KEY'` with actual key
- License applies to shell and all MFEs automatically

❌ **Common Mistakes**:
- Registering in main.ts (causes import errors)
- Registering in each MFE (unnecessary duplication)
- Forgetting to replace placeholder key

## Related Files
- `apps/shell/src/bootstrap.ts` - License registration location
- `apps/shell/federation.config.js` - Syncfusion packages shared configuration
- `SYNCFUSION_INTEGRATION.md` - General Syncfusion integration guide
