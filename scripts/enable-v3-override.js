const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(__dirname, '..', 'package.json');
const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));

console.log('🔄 Enabling V3 Override...\n');

// Redirect all to v3
packageJson.dependencies['shared-ui-v1'] = 'file:artifacts/shared-ui-3.0.0.tgz';
packageJson.dependencies['shared-ui-v2'] = 'file:artifacts/shared-ui-3.0.0.tgz';

fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + '\n');

console.log('✅ V3 override ENABLED');
console.log('📦 Package aliases updated:');
console.log('   shared-ui-v1 → artifacts/shared-ui-3.0.0.tgz');
console.log('   shared-ui-v2 → artifacts/shared-ui-3.0.0.tgz');
console.log('   shared-ui-v3 → artifacts/shared-ui-3.0.0.tgz');
console.log('\n🔄 Running npm install...');
console.log('⚠️  After install completes, restart all apps:');
console.log('   - npm run serve:shell');
console.log('   - npm run serve:mfe1');
console.log('   - npm run serve:mfe2');
console.log('\n🎯 Expected result: All MFEs will show RED badges (v3.0.0)');
