# 🎨 Visual Demo Guide - How to See the Badges and Use Override

This guide shows you exactly how to see the version badges and demonstrates the override functionality.

## 🚀 Step 1: Start All Applications

You need three terminal windows running simultaneously:

### Terminal 1 - MFE1
```bash
cd shared-hub-poc
npm run serve:mfe1
```
Wait for: `✔ Browser application bundle generation complete.`

### Terminal 2 - MFE2
```bash
cd shared-hub-poc
npm run serve:mfe2
```
Wait for: `✔ Browser application bundle generation complete.`

### Terminal 3 - Shell
```bash
cd shared-hub-poc
npm run serve:shell
```
Wait for: `✔ Browser application bundle generation complete.`

## 👀 Step 2: View the Application

Open your browser to: **http://localhost:4200**

### What You Should See on Home Page:

1. **Title**: "Shared Library Version Management Demo"
2. **Architecture Diagram** explaining the system
3. **Key Benefits** cards (Team Autonomy, Central Control, Gradual Migration)
4. **Two MFE Cards**:
   - MFE1 card with blue badge showing "v1.0.0"
   - MFE2 card with green badge showing "v2.0.0"
5. **Version Override** section explaining v3.0.0
6. **Central Dependency Management** section showing Angular, Bootstrap, RxJS

## 🔵 Step 3: See MFE1 Badge (Blue - v1.0.0)

1. Click the **"Open MFE1"** button on the home page
2. URL changes to: `http://localhost:4200/mfe1`
3. You should see:
   - A card with title "mfe1"
   - **BLUE BADGE** in the top right showing "Shared UI" and version "1.0.0"
   - Text: "This is MFE1 using shared-ui v1.0.0"
   - Info box explaining version independence

### If you DON'T see the badge:
- Check browser console for errors (F12)
- Verify MFE1 is running on port 4201
- Check that shared-ui-v1 is installed: `npm list shared-ui-v1`

## 🟢 Step 4: See MFE2 Badge (Green - v2.0.0)

1. Click **"Home"** in the navigation bar
2. Click the **"Open MFE2"** button
3. URL changes to: `http://localhost:4200/mfe2`
4. You should see:
   - A card with title "mfe2"
   - **GREEN BADGE** in the top right showing "Shared UI" and version "2.0.0"
   - Text: "This is MFE2 using shared-ui v2.0.0"
   - Info box explaining version independence

## 🔴 Step 5: Enable Version Override (Force v3.0.0)

Currently, the shell is configured to ALLOW override but not FORCE it. To see the override in action:

### Option A: Modify Shell Config (Recommended for Demo)

1. **Stop the shell** (Ctrl+C in Terminal 3)

2. **Edit the shell federation config**:
   ```bash
   # Open in your editor
   code shared-hub-poc/apps/shell/federation.config.js
   ```

3. **Find the shared-ui-v3 section** and ensure it looks like this:
   ```javascript
   'shared-ui-v3': {
     singleton: true,     // ← Must be true
     strictVersion: false,
     requiredVersion: '3.0.0',
     version: '3.0.0',
     eager: true,         // ← Must be true to force override
   },
   ```

4. **Also REMOVE or comment out v1 and v2** to force v3:
   ```javascript
   // Comment these out to force v3:
   // 'shared-ui-v1': { ... },
   // 'shared-ui-v2': { ... },
   ```

5. **Restart the shell**:
   ```bash
   npm run serve:shell
   ```

6. **Refresh browser** and navigate to MFE1 and MFE2
7. **Both should now show RED BADGES** with version "3.0.0"!

### Option B: Import v3 in Shell (Alternative Method)

1. **Edit shell's app.ts**:
   ```typescript
   // Add this import to force v3 to load
   import 'shared-ui-v3';
   ```

2. **Restart shell**
3. **Both MFEs will now use v3**

## 📊 Step 6: Verify Central Dependency Management

### Check in Browser DevTools:

1. Open **DevTools** (F12)
2. Go to **Network** tab
3. **Reload** the page
4. **Navigate to MFE1**
5. Look at network requests:
   - Angular chunks should NOT be loaded again (cached from shell)
   - Bootstrap should NOT be loaded again (cached from shell)
   - Only MFE1-specific code is loaded

6. **Navigate to MFE2**
7. Same behavior - no duplicate Angular/Bootstrap loads!

### Check in Console:

```javascript
// In browser console, check Angular version
import('@angular/core').then(ng => console.log('Angular version:', ng.VERSION.full));

// Should show: Angular version: 20.0.0 (from shell)
```

## 🎯 Expected Visual Results

### Normal Mode (No Override):
```
Home Page:
├── MFE1 Card: Blue badge "v1.0.0"
└── MFE2 Card: Green badge "v2.0.0"

MFE1 Page:
└── Blue badge "Shared UI v1.0.0"

MFE2 Page:
└── Green badge "Shared UI v2.0.0"
```

### Override Mode (v3 Forced):
```
Home Page:
├── MFE1 Card: Blue badge "v1.0.0" (still shows intended version)
└── MFE2 Card: Green badge "v2.0.0" (still shows intended version)

MFE1 Page:
└── RED badge "Shared UI v3.0.0" ← OVERRIDDEN!

MFE2 Page:
└── RED badge "Shared UI v3.0.0" ← OVERRIDDEN!
```

## 🎨 Badge Color Reference

The badges use Bootstrap's color classes:

| Version | Color | Bootstrap Class | Meaning |
|---------|-------|----------------|---------|
| v1.0.0 | 🔵 Blue | `text-bg-primary` | MFE1's version |
| v2.0.0 | 🟢 Green | `text-bg-success` | MFE2's version |
| v3.0.0 | 🔴 Red | `text-bg-danger` | Shell's override version |

## 🐛 Troubleshooting

### Problem: No badges visible

**Check 1**: Are all three apps running?
```bash
# Should see three processes
netstat -ano | findstr "4200 4201 4202"
```

**Check 2**: Is shared-ui installed?
```bash
cd shared-hub-poc
npm list shared-ui-v1 shared-ui-v2 shared-ui-v3
```

**Check 3**: Browser console errors?
- Open DevTools (F12)
- Check Console tab for errors
- Check Network tab for failed requests

### Problem: Badges show but wrong color

**Check**: Which version is actually loaded?
```javascript
// In browser console
import('shared-ui-v1').then(m => console.log('v1:', m.SHARED_UI_VERSION));
import('shared-ui-v2').then(m => console.log('v2:', m.SHARED_UI_VERSION));
import('shared-ui-v3').then(m => console.log('v3:', m.SHARED_UI_VERSION));
```

### Problem: Override not working

**Check 1**: Shell federation config
```javascript
// Must have:
'shared-ui-v3': {
  singleton: true,  // ← Required
  eager: true,      // ← Required
}
```

**Check 2**: Restart shell after config changes
```bash
# Stop shell (Ctrl+C)
npm run serve:shell
```

**Check 3**: Clear browser cache
- Hard refresh: Ctrl+Shift+R
- Or clear cache in DevTools

## 📸 Screenshots Guide

### What to Screenshot for Demo:

1. **Home Page** - Shows architecture and both MFE cards with badges
2. **MFE1 Page** - Blue badge visible
3. **MFE2 Page** - Green badge visible
4. **DevTools Network Tab** - Showing no duplicate Angular loads
5. **After Override** - Both MFEs showing red badges

## 🎬 Demo Script

For presenting this to stakeholders:

1. **Start**: "Let me show you our version management system..."
2. **Home Page**: "Here we have two microfrontends, each using different versions"
3. **MFE1**: "MFE1 uses version 1 - see the blue badge"
4. **MFE2**: "MFE2 uses version 2 - see the green badge"
5. **DevTools**: "Notice Angular is only loaded once, shared by both"
6. **Override**: "Now watch what happens when we need to force an update..."
7. **After Override**: "Both MFEs now use version 3 - red badges!"
8. **Conclusion**: "This gives us team autonomy with central control"

## 🚀 Quick Demo Commands

```bash
# Start everything
cd shared-hub-poc
npm run serve:mfe1 &
npm run serve:mfe2 &
npm run serve:shell &

# Wait for builds, then open browser
start http://localhost:4200

# To enable override:
# 1. Edit apps/shell/federation.config.js
# 2. Comment out shared-ui-v1 and shared-ui-v2
# 3. Restart shell
# 4. Refresh browser
```

## ✅ Success Checklist

- [ ] All three apps running (ports 4200, 4201, 4202)
- [ ] Home page loads with architecture explanation
- [ ] MFE1 shows blue badge (v1.0.0)
- [ ] MFE2 shows green badge (v2.0.0)
- [ ] Navigation works between pages
- [ ] DevTools shows no duplicate Angular loads
- [ ] Override configuration understood
- [ ] Can demonstrate override by modifying config

---

**Need Help?** Check the browser console (F12) for any error messages!
