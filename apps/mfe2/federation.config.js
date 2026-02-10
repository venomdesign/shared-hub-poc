const { withNativeFederation, shareAll } = require('@angular-architects/native-federation/config');

module.exports = withNativeFederation({
  name: 'mfe2',

  exposes: {
    './Component': './apps/mfe2/src/app/app.ts',
  },

  shared: {
    ...shareAll({ singleton: true, strictVersion: true, requiredVersion: 'auto' }),
    
    // Syncfusion packages - will use shell's versions
    '@syncfusion/ej2-angular-grids': {
      singleton: true,
      strictVersion: false,
      requiredVersion: '29.2.11',
    },
    '@syncfusion/ej2-grids': {
      singleton: true,
      strictVersion: false,
      requiredVersion: '29.2.11',
    },
    
    // MFE2 uses shared-ui v2.0.0
    'shared-ui-v2': {
      singleton: false, // Allow version coexistence
      strictVersion: false, // Don't enforce strict version matching
      requiredVersion: '2.0.0',
      version: '2.0.0',
    },
  },

  skip: [
    'rxjs/ajax',
    'rxjs/fetch',
    'rxjs/testing',
    'rxjs/webSocket',
    // Add further packages you don't need at runtime
  ],

  // Please read our FAQ about sharing libs:
  // https://shorturl.at/jmzH0

  features: {
    // New feature for more performance and avoiding
    // issues with node libs. Comment this out to
    // get the traditional behavior:
    ignoreUnusedDeps: true
  }
});
