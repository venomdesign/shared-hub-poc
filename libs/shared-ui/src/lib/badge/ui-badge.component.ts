import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SHARED_UI_VERSION } from '../version';

@Component({
  selector: 'shared-ui-badge',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './ui-badge.component.html',
  styleUrls: ['./ui-badge.component.scss'],
})
export class UiBadgeComponent {
  @Input() label = 'UI Kit';
  version = SHARED_UI_VERSION;

  get badgeClass(): string {
    // Return different Bootstrap badge classes based on version
    switch (this.version) {
      case '1.0.0':
        return 'text-bg-primary'; // Blue
      case '2.0.0':
        return 'text-bg-success'; // Green
      case '3.0.0':
        return 'text-bg-danger'; // Red
      default:
        return 'text-bg-secondary'; // Gray
    }
  }
}
