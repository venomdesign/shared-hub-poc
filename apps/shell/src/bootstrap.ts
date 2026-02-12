import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import { registerLicense } from '@syncfusion/ej2-base';

const key = 'Ngo9BigBOggjHTQxAR8/V1JGaF5cXGpCf1FpRmJGdld5fUVHYVZUTXxaS00DNHVRdkdlWX1ednVURGFZUUdwVkRWYEs='

registerLicense(key);

bootstrapApplication(App, appConfig)
  .catch((err) => console.error(err));
