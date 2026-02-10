# Shared Library Version Management Architecture

## Overview

This project demonstrates a sophisticated version management system for shared libraries in a microfrontend architecture. It showcases how different teams can maintain their microfrontends at different paces while still allowing central control when needed.

## Architecture

### Version Strategy

- **MFE1**: Uses `shared-ui v1.0.0` (Blue badge)
- **MFE2**: Uses `shared-ui v2.0.0` (Green badge)
- **Shell**: Can override both to use `shared-ui v3.0.0` (Red badge)

### Key Components

#### 1. Shared UI Library Versions

Three versions of the shared-ui library are built and packaged:

```bash
artifacts/
├── shared-ui-1.0.0.tgz
├── shared-ui-2.0.0.tgz
└── shared-ui-3.0.0.tgz
```

Each version is installed as a separate npm alias:
- `shared-ui-v1` → `file:artifacts/shared-ui-1.0.0.tgz`
- `shared-ui-v2` → `file:artifacts/shared-ui-2.0.0.tgz`
- `shared-ui-v3` → `file:artifacts/shared-ui-3.0.0.tgz`

#### 2. MFE1 Configuration

**Import:**
```typescript
import { UiBadgeComponent } from 'shared-ui-v1';
```

**Federation Config:**
```javascript
shared: {
  'shared-ui-v1': {
    singleton: false,      // Allow version coexistence
    strictVersion: false,  // Don't enforce strict version matching
    requiredVersion: '1.0.0',
    version: '1.0.0',
  },
}
```

#### 3. MFE2 Configuration

**Import:**
```typescript
import { UiBadgeComponent } from 'shared-ui-v2';
```

**Federation Config:**
```javascript
shared: {
  'shared-ui-v2': {
    singleton: false,      // Allow version coexistence
    strictVersion: false,  // Don't enforce strict version matching
    requiredVersion: '2.0.0',
    version: '2.0.0',
  },
}
```

#### 4. Shell Configuration (Override Capability)

**Federation Config:**
```javascript
shared: {
  // v3 as override - takes precedence when loaded
  'shared-ui-v3': {
    singleton: true,       // Enforce single version across all MFEs
    strictVersion: false,  // Allow override
    requiredVersion: '3.0.0',
    version: '3.0.0',
    eager: true,          // Load immediately with shell
  },
  
  // Also share v1 and v2 for fallback
  'shared-ui-v1': {
    singleton: false,
    strictVersion: false,
    requiredVersion: '1.0.0',
    version: '1.0.0',
  },
  'shared-ui-v2': {
    singleton: false,
    strictVersion: false,
    requiredVersion: '2.0.0',
    version: '2.0.0',
  },
}
```

## How It Works

### Normal Operation (No Override)

1. **MFE1** loads and uses `shared-ui-v1` (blue badge)
2. **MFE2** loads and uses `shared-ui-v2` (green badge)
3. Each MFE operates independently with its preferred version

### Override Mode (Shell Enforces v3)

When the shell's federation config has `shared-ui-v3` with:
- `singleton: true` - Only one instance allowed
- `eager: true` - Loaded immediately with shell

Then:
1. Shell loads `shared-ui-v3` first
2. When MFE1 tries to load `shared-ui-v1`, it gets `shared-ui-v3` instead (red badge)
3. When MFE2 tries to load `shared-ui-v2`, it gets `shared-ui-v3` instead (red badge)
4. All MFEs now use the same version enforced by the shell

## Benefits

### 1. Team Autonomy
- Teams can upgrade dependencies independently
- No blocking between teams
- Each team controls their own pace

### 2. Central Control
- Shell can force critical updates
- Security patches can be enforced immediately
- Breaking changes can be rolled out in a controlled manner

### 3. Gradual Migration
- Teams can fall behind on versions temporarily
- Migration can happen incrementally
- No "big bang" upgrades required

### 4. Version Visibility
- Color-coded badges show which version is in use
- Easy to identify which MFEs need updates
- Clear visual feedback for developers

## Visual Indicators

The `UiBadgeComponent` uses color-coding to indicate versions:

```typescript
get badgeClass(): string {
  switch (this.version) {
    case '1.0.0':
      return 'text-bg-primary';  // Blue
    case '2.0.0':
      return 'text-bg-success';  // Green
    case '3.0.0':
      return 'text-bg-danger';   // Red
    default:
      return 'text-bg-secondary'; // Gray
  }
}
```

## Building Versions

To rebuild all versions of the shared-ui library:

```bash
cd shared-hub-poc
./scripts/build-all-shared-ui-versions.sh
```

This script:
1. Updates the version constant in `libs/shared-ui/src/lib/version.ts`
2. Builds the library with `ng build shared-ui`
3. Patches the `package.json` with the correct version
4. Packs the library into a `.tgz` file
5. Moves it to the `artifacts/` directory
6. Registers npm aliases in the root `package.json`
7. Runs `npm install` to install all versions

## Testing the Implementation

### Test Case 1: Version Independence
1. Start all applications:
   ```bash
   npm run serve:mfe1  # Terminal 1
   npm run serve:mfe2  # Terminal 2
   npm run serve:shell # Terminal 3
   ```
2. Navigate to http://localhost:4200
3. Click on MFE1 - should show **blue badge** (v1.0.0)
4. Click on MFE2 - should show **green badge** (v2.0.0)

### Test Case 2: Version Override
1. Modify shell's federation config to enable eager loading of v3
2. Restart the shell application
3. Navigate to MFE1 - should show **red badge** (v3.0.0)
4. Navigate to MFE2 - should show **red badge** (v3.0.0)

## Real-World Use Cases

### Use Case 1: Security Patch
A critical security vulnerability is found in shared-ui v1 and v2.

**Solution:**
1. Release shared-ui v3 with the fix
2. Update shell's federation config to enforce v3
3. All MFEs immediately use the patched version
4. Teams can update their code at their own pace

### Use Case 2: Breaking Changes
shared-ui v3 introduces breaking changes.

**Solution:**
1. Teams test their MFEs with v3 independently
2. Each team updates when ready
3. Shell doesn't enforce v3 until all teams are ready
4. Gradual rollout without downtime

### Use Case 3: Feature Parity
New features in v3 need to be available to all MFEs.

**Solution:**
1. Shell enforces v3 temporarily
2. All MFEs get new features immediately
3. Teams update their imports over time
4. Shell can revert to non-enforced mode once teams update

## Configuration Options

### Singleton Mode
- `singleton: true` - Only one version can exist
- `singleton: false` - Multiple versions can coexist

### Strict Version
- `strictVersion: true` - Exact version match required
- `strictVersion: false` - Version can be overridden

### Eager Loading
- `eager: true` - Load with the shell immediately
- `eager: false` - Load on demand

### Required Version
- Specifies the version this module expects
- Used for compatibility checking

## Best Practices

1. **Version Naming**: Use semantic versioning (major.minor.patch)
2. **Color Coding**: Use consistent colors for version identification
3. **Documentation**: Keep version changes documented
4. **Testing**: Test each version independently before deployment
5. **Communication**: Notify teams before enforcing version overrides
6. **Monitoring**: Track which MFEs are using which versions
7. **Gradual Rollout**: Don't force updates unless critical

## Troubleshooting

### Issue: MFE shows wrong version
**Solution**: Check federation config, ensure correct import path

### Issue: Version override not working
**Solution**: Verify `singleton: true` and `eager: true` in shell config

### Issue: Build errors after version change
**Solution**: Clear node_modules and reinstall dependencies

### Issue: Multiple versions loading simultaneously
**Solution**: Check singleton settings in federation configs

## Future Enhancements

1. **Dynamic Override Toggle**: Add UI to enable/disable override at runtime
2. **Version Analytics**: Track version usage across MFEs
3. **Automated Testing**: Test all version combinations automatically
4. **Version Compatibility Matrix**: Document which versions work together
5. **Rollback Mechanism**: Quick rollback if override causes issues

## Conclusion

This version management system provides the perfect balance between team autonomy and central control. Teams can work independently while the platform maintains the ability to enforce critical updates when needed.
