# Serve Commands Fix Summary

## Problem
The `npm run serve:shell`, `npm run serve:mfe1`, and `npm run serve:mfe2` commands were not staying running consistently. They would start the build process but then exit back to the bash prompt instead of keeping the dev server alive.

## Root Cause
The Native Federation builder configuration in `angular.json` had issues with:
1. **rebuildDelay**: Set to 500ms which could cause timing issues
2. **cacheExternalArtifacts**: This option was causing conflicts
3. **Missing configurations**: No explicit development/production configurations for the serve target

## Solution Applied

### Changes to `angular.json`

For all three applications (shell, mfe1, mfe2), the `serve` configuration was updated:

**Before:**
```json
"serve": {
  "builder": "@angular-architects/native-federation:build",
  "options": {
    "target": "shell:serve-original:development",
    "rebuildDelay": 500,
    "dev": true,
    "cacheExternalArtifacts": false,
    "port": 4200
  }
}
```

**After:**
```json
"serve": {
  "builder": "@angular-architects/native-federation:build",
  "options": {
    "target": "shell:serve-original:development",
    "rebuildDelay": 0,
    "dev": true,
    "port": 4200
  },
  "configurations": {
    "development": {
      "target": "shell:serve-original:development"
    },
    "production": {
      "target": "shell:serve-original:production"
    }
  }
}
```

### Key Changes:
1. ✅ **rebuildDelay**: Changed from `500` to `0` for immediate rebuilds
2. ✅ **Removed cacheExternalArtifacts**: This option was causing conflicts with the Native Federation builder
3. ✅ **Added configurations**: Explicit development and production configurations for better control

## Results

All three servers now start and stay running properly:

- **Shell**: `npm run serve:shell` → http://localhost:4200/
- **MFE1**: `npm run serve:mfe1` → http://localhost:4201/
- **MFE2**: `npm run serve:mfe2` → http://localhost:4202/

## Testing

To verify the fix works:

1. Open three separate terminals
2. Run each command in a different terminal:
   ```bash
   npm run serve:shell
   npm run serve:mfe1
   npm run serve:mfe2
   ```
3. All three should build successfully and display:
   ```
   ➜  Local:   http://localhost:XXXX/
   ➜  press h + enter to show help
   ```

## Notes

- The UIBadgeComponent warning in the shell app is expected and can be ignored (as per user request)
- All servers use watch mode and will automatically rebuild on file changes
- The Native Federation builder properly delegates to the `serve-original` target which uses the Angular dev server

## Date Fixed
February 11, 2026
