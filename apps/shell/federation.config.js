const { withNativeFederation, shareAll } = require('@angular-architects/native-federation/config');

module.exports = withNativeFederation({
  name: 'shell',

  shared: {
    ...shareAll({ singleton: true, strictVersion: true, requiredVersion: 'auto' }),
    
    // Shell can provide shared-ui v3 as an override
    // When enabled, this forces all MFEs to use v3 regardless of their own version
    'shared-ui-v3': {
      singleton: true, // Enforce single version across all MFEs
      strictVersion: false, // Allow override
      requiredVersion: '3.0.0',
      version: '3.0.0',
      eager: true, // Load immediately with shell
    },
    
    // Also share v1 and v2 to allow MFEs to use their preferred versions
    // when override is not active
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
