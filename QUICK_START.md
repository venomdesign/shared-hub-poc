# 🚀 Quick Start - See the Badges NOW!

## ✅ All Apps Are Running!

- ✅ MFE1: http://localhost:4201
- ✅ MFE2: http://localhost:4202  
- ✅ Shell: http://localhost:4200

## 👀 Open Your Browser

**Main URL**: http://localhost:4200

## 🎯 What You'll See

### 1. Home Page (http://localhost:4200)
- Architecture explanation
- Two cards for MFE1 and MFE2
- Version management info
- Central dependency management section

### 2. Click "Open MFE1" Button
- URL: http://localhost:4200/mfe1
- **Look for**: 🔵 **BLUE BADGE** in top-right corner
- Badge text: "Shared UI" with version "1.0.0"

### 3. Click "Open MFE2" Button  
- URL: http://localhost:4200/mfe2
- **Look for**: 🟢 **GREEN BADGE** in top-right corner
- Badge text: "Shared UI" with version "2.0.0"

## 🔴 Want to See the Override? (Red Badge)

### Quick Method:

1. **Stop the shell** (press Ctrl+C in the shell terminal)

2. **Edit this file**: `shared-hub-poc/apps/shell/federation.config.js`

3. **Find line ~15** and change:
   ```javascript
   // BEFORE:
   'shared-ui-v1': {
     singleton: false,
   
   // AFTER:
   'shared-ui-v1': {
     singleton: true,  // ← Change to true
   ```

4. **Also change v2**:
   ```javascript
   // BEFORE:
   'shared-ui-v2': {
     singleton: false,
   
   // AFTER:
   'shared-ui-v2': {
     singleton: true,  // ← Change to true
   ```

5. **Restart shell**:
   ```bash
   npm run serve:shell
   ```

6. **Refresh browser** and click MFE1 or MFE2
7. **Both now show 🔴 RED BADGES** with version "3.0.0"!

## 🐛 Not Seeing Badges?

### Check 1: Open Browser Console (F12)
- Look for any red error messages
- Common issue: Module not found

### Check 2: Verify Packages Installed
```bash
cd shared-hub-poc
npm list shared-ui-v1 shared-ui-v2 shared-ui-v3
```

Should show all three versions installed.

### Check 3: Hard Refresh
- Press: **Ctrl + Shift + R** (Windows)
- Or: **Cmd + Shift + R** (Mac)

## 📸 What the Badges Look Like

```
┌─────────────────────────────────┐
│  mfe1              [Shared UI]  │  ← Blue badge here
│                      v1.0.0     │
│                                 │
│  This is MFE1 using...          │
└─────────────────────────────────┘
```

The badge is a Bootstrap badge component in the top-right corner of the card.

## 🎨 Badge Colors

| Version | Color | What It Means |
|---------|-------|---------------|
| v1.0.0 | 🔵 Blue | MFE1's preferred version |
| v2.0.0 | 🟢 Green | MFE2's preferred version |
| v3.0.0 | 🔴 Red | Shell's override version |

## ⚡ Quick Commands

```bash
# Open browser
start http://localhost:4200

# Check if apps are running
netstat -ano | findstr "4200 4201 4202"

# Restart shell (if you made config changes)
# 1. Press Ctrl+C in shell terminal
# 2. Run:
npm run serve:shell
```

## 📚 Full Documentation

- **VISUAL_DEMO_GUIDE.md** - Complete step-by-step guide
- **VERSION_MANAGEMENT.md** - Technical architecture details
- **CENTRAL_DEPENDENCY_MANAGEMENT.md** - Dependency management info

---

**🎉 Enjoy the demo! The badges should be clearly visible in the top-right corner of each MFE page.**
