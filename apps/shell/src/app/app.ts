import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';

// Import all three versions to make them available in the shared scope
// The shell's federation config controls which version MFEs actually get
import { UiBadgeComponent as BadgeV1 } from 'shared-ui-v1';
import { UiBadgeComponent as BadgeV2 } from 'shared-ui-v2';
import { UiBadgeComponent as BadgeV3 } from 'shared-ui-v3';

// Use v3 for the shell itself
const UiBadgeComponent = BadgeV3;

@Component({
  selector: 'app-root',
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive, UiBadgeComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('shell');
}
