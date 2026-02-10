import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SHARED_UI_VERSION } from '../version';

/**
 * Badge component that displays a version badge with automatic color coding.
 * 
 * The badge reads the version from the package.json file and applies color coding:
 * - v1.0.0: Blue badge
 * - v2.0.0: Green badge
 * - v3.0.0: Red badge
 * 
 * @example
 * Basic usage:
 * ```html
 * <shared-ui-badge label="My App"></shared-ui-badge>
 * ```
 * 
 * @example
 * With custom label:
 * ```html
 * <shared-ui-badge label="Shared UI"></shared-ui-badge>
 * ```
 * 
 * @example
 * In a component:
 * ```typescript
 * import { UiBadgeComponent } from 'shared-ui-v1';
 * 
 * @Component({
 *   selector: 'app-example',
 *   standalone: true,
 *   imports: [UiBadgeComponent],
 *   template: `<shared-ui-badge label="Example"></shared-ui-badge>`
 * })
 * export class ExampleComponent {}
 * ```
 */
@Component({
  selector: 'shared-ui-badge',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './ui-badge.component.html',
  styleUrls: ['./ui-badge.component.scss'],
})
export class UiBadgeComponent {
  /**
   * The label text to display before the version number.
   * @default 'UI Kit'
   */
  @Input() label = 'UI Kit';
  
  /**
   * The version number read from package.json.
   * This is automatically set and should not be modified.
   */
  version = SHARED_UI_VERSION;

  /**
   * Returns the Bootstrap badge class based on the version number.
   * 
   * @returns The CSS class string for the badge
   * 
   * Version to class mapping:
   * - '1.0.0' → 'text-bg-primary' (Blue)
   * - '2.0.0' → 'text-bg-success' (Green)
   * - '3.0.0' → 'text-bg-danger' (Red)
   * - default → 'text-bg-secondary' (Gray)
   */
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
