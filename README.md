# Shared Library Version Management Demo

A comprehensive demonstration of version management in microfrontend architectures using Angular Native Federation.

## 🎯 Overview

This project showcases a real-world solution for managing shared library versions across multiple microfrontends, where:

- **MFE1** uses `shared-ui v1.0.0` 🔵 (Blue badge)
- **MFE2** uses `shared-ui v2.0.0` 🟢 (Green badge)
- **Shell** can override both to use `shared-ui v3.0.0` 🔴 (Red badge)

This architecture enables **team autonomy** while maintaining **central control** for critical updates.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Shell (Host)                         │
│  Port: 4200                                             │
│  - Provides navigation                                  │
│  - Can enforce shared-ui v3.0.0 override               │
│  - Controls version management                          │
└─────────────────────────────────────────────────────────┘
                    │                │
        ┌───────────┘                └───────────┐
        │                                        │
┌───────▼────────┐                      ┌───────▼────────┐
│     MFE1       │                      │     MFE2       │
│  Port: 4201    │                      │  Port: 4202    │
│  shared-ui     │                      │  shared-ui     │
│   v1.0.0 🔵    │                      │   v2.0.0 🟢    │
└────────────────┘                      └────────────────┘
```

## ✨ Key Features

### 1. Version Independence
Each microfrontend can use its preferred version of shared libraries without affecting others.

### 2. Central Override Capability
The shell can force all MFEs to use a specific version when critical updates are needed.

### 3. Visual Version Indicators
Color-coded badges clearly show which version each MFE is using:
- 🔵 Blue = v1.0.0
- 🟢 Green = v2.0.0
- 🔴 Red = v3.0.0

### 4. Gradual Migration
Teams can update at their own pace without blocking each other.

## 🚀 Quick Start

### Prerequisites

- Node.js (v18 or higher)
- npm (v9 or higher)
- Angular CLI (v20 or higher)

### Installation

```bash
# Clone the repository
cd shared-hub-poc

# Install dependencies
npm install
```

### Running the Application

You need to run all three applications in separate terminals:

**Terminal 1 - Start MFE1:**
```bash
npm run serve:mfe1
```

**Terminal 2 - Start MFE2:**
```bash
npm run serve:mfe2
```

**Terminal 3 - Start Shell:**
```bash
npm run serve:shell
```

### Access the Application

Open your browser to: **http://localhost:4200**

## 📋 What to Expect

### Home Page
- Comprehensive explanation of version management architecture
- Key benefits overview
- Links to both MFEs with version indicators

### MFE1 (http://localhost:4200/mfe1)
- Displays **blue badge** showing v1.0.0
- Demonstrates independent version usage

### MFE2 (http://localhost:4200/mfe2)
- Displays **green badge** showing v2.0.0
- Demonstrates independent version usage

### Version Override
When shell's override is active, both MFEs will show **red badges** (v3.0.0), demonstrating central control.

## 📚 Documentation

- **[VERSION_MANAGEMENT.md](./VERSION_MANAGEMENT.md)** - Complete architecture and implementation details
- **[NAVIGATION_IMPLEMENTATION.md](./NAVIGATION_IMPLEMENTATION.md)** - Navigation setup and routing
- **[TODO.md](./TODO.md)** - Implementation checklist and status
- **[TEST_REPORT.md](./TEST_REPORT.md)** - Testing results and procedures

## 🔧 Technical Details

### Technology Stack

- **Angular**: v20.0.0
- **Native Federation**: @angular-architects/native-federation v21.1.0
- **Bootstrap**: v5.3.8
- **TypeScript**: v5.8.2

### Project Structure

```
shared-hub-poc/
├── apps/
│   ├── shell/          # Host application (port 4200)
│   ├── mfe1/           # Microfrontend 1 (port 4201)
│   └── mfe2/           # Microfrontend 2 (port 4202)
├── libs/
│   └── shared-ui/      # Shared UI library
├── artifacts/          # Built library versions
│   ├── shared-ui-1.0.0.tgz
│   ├── shared-ui-2.0.0.tgz
│   └── shared-ui-3.0.0.tgz
└── scripts/            # Build and setup scripts
```

### Federation Configuration

#### MFE1 (uses v1.0.0)
```javascript
shared: {
  'shared-ui-v1': {
    singleton: false,
    strictVersion: false,
    requiredVersion: '1.0.0',
    version: '1.0.0',
  },
}
```

#### MFE2 (uses v2.0.0)
```javascript
shared: {
  'shared-ui-v2': {
    singleton: false,
    strictVersion: false,
    requiredVersion: '2.0.0',
    version: '2.0.0',
  },
}
```

#### Shell (provides v3.0.0 override)
```javascript
shared: {
  'shared-ui-v3': {
    singleton: true,      // Enforce single version
    strictVersion: false,
    requiredVersion: '3.0.0',
    version: '3.0.0',
    eager: true,         // Load immediately
  },
  // Also shares v1 and v2 for fallback
}
```

## 🎓 Use Cases

### Use Case 1: Security Patch
A critical vulnerability is found in v1 and v2.

**Solution:**
1. Release v3 with the fix
2. Shell enforces v3 override
3. All MFEs immediately use patched version
4. Teams update their code at their own pace

### Use Case 2: Breaking Changes
v3 introduces breaking changes.

**Solution:**
1. Teams test with v3 independently
2. Each team updates when ready
3. No forced updates until all teams are prepared
4. Gradual rollout without downtime

### Use Case 3: Feature Rollout
New features in v3 need to be available everywhere.

**Solution:**
1. Shell temporarily enforces v3
2. All MFEs get new features immediately
3. Teams update their imports over time
4. Shell reverts to non-enforced mode once complete

## 🔨 Building Shared Library Versions

To rebuild all versions of the shared-ui library:

```bash
cd shared-hub-poc
./scripts/build-all-shared-ui-versions.sh
```

This script:
1. Updates version constant for each version
2. Builds the library
3. Patches package.json with correct version
4. Packs into .tgz files
5. Installs as npm aliases

## 🧪 Testing

### Manual Testing Checklist

- [ ] Start all three applications
- [ ] Navigate to home page - verify version info displays
- [ ] Click MFE1 - verify blue badge (v1.0.0)
- [ ] Click MFE2 - verify green badge (v2.0.0)
- [ ] Check browser console for errors
- [ ] Verify navigation works correctly
- [ ] Test responsive design on mobile

### Testing Version Override

1. Verify shell's federation config has v3 with `singleton: true` and `eager: true`
2. Restart shell application
3. Navigate to MFE1 - should show red badge (v3.0.0)
4. Navigate to MFE2 - should show red badge (v3.0.0)

## 💡 Benefits

### For Development Teams
- ✅ Update dependencies independently
- ✅ Test new versions without affecting others
- ✅ Fall behind temporarily without breaking the system
- ✅ Control your own release schedule

### For Platform Teams
- ✅ Force critical updates when needed
- ✅ See which teams are using which versions
- ✅ Roll back problematic updates quickly
- ✅ Maintain governance and safety

### For the Organization
- ✅ Reduced risk with gradual rollouts
- ✅ Faster delivery with parallel development
- ✅ Better quality with more testing time
- ✅ Improved team autonomy and morale

## 🐛 Troubleshooting

### Issue: MFE shows wrong version
**Solution**: Check federation config and import paths

### Issue: Version override not working
**Solution**: Verify `singleton: true` and `eager: true` in shell config

### Issue: Build errors
**Solution**: Clear node_modules and reinstall dependencies

### Issue: Port already in use
**Solution**: Kill processes on ports 4200, 4201, 4202 or change ports in package.json

## 🤝 Contributing

This is a demonstration project. Feel free to:
- Experiment with different configurations
- Add more MFEs
- Create additional shared library versions
- Implement dynamic override toggles

## 📝 License

This project is for demonstration purposes.

## 🙏 Acknowledgments

- Angular Team for Native Federation
- Manfred Steyer for Module Federation concepts
- Bootstrap for UI components

## 📞 Support

For questions or issues:
1. Check the documentation in VERSION_MANAGEMENT.md
2. Review the TEST_REPORT.md for common issues
3. Examine the federation configs for each application

## 🎯 Next Steps

After exploring this demo, consider:
1. Implementing similar architecture in your projects
2. Adding automated version compatibility testing
3. Creating version migration guides for your teams
4. Building a version analytics dashboard
5. Implementing dynamic override controls

---

**Built with ❤️ to demonstrate real-world microfrontend version management**
