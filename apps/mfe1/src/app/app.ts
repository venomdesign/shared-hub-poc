import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { UiBadgeComponent, SHARED_UI_VERSION } from 'shared-ui-v1';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, UiBadgeComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('mfe1');
  protected readonly actualVersion = SHARED_UI_VERSION;
  protected readonly requestedVersion = '1.0.0';
  protected readonly isOverridden = (SHARED_UI_VERSION as string) !== this.requestedVersion;
}
