const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(__dirname, '..', 'package.json');
const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));

console.log('🔄 Disabling V3 Override...\n');

// Restore original versions
packageJson.dependencies['shared-ui-v1'] = 'file:artifacts/shared-ui-1.0.0.tgz';
packageJson.dependencies['shared-ui-v2'] = 'file:artifacts/shared-ui-2.0.0.tgz';

fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + '\n');

console.log('✅ V3 override DISABLED');
console.log('📦 Package aliases restored:');
console.log('   shared-ui-v1 → artifacts/shared-ui-1.0.0.tgz');
console.log('   shared-ui-v2 → artifacts/shared-ui-2.0.0.tgz');
console.log('   shared-ui-v3 → artifacts/shared-ui-3.0.0.tgz');
console.log('\n🔄 Running npm install...');
console.log('⚠️  After install completes, restart all apps:');
console.log('   - npm run serve:shell');
console.log('   - npm run serve:mfe1');
console.log('   - npm run serve:mfe2');
console.log('\n🎯 Expected result:');
console.log('   - MFE1 will show BLUE badge (v1.0.0)');
console.log('   - MFE2 will show GREEN badge (v2.0.0)');
