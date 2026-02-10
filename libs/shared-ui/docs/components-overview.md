# Components Overview

This page provides an overview of all available components in the Shared UI library.

## Badge Component

**Location:** `libs/shared-ui/src/lib/badge/ui-badge.component.ts`

### Description

The Badge component displays a version badge with automatic color coding based on the library version. It reads the version directly from the package.json file, ensuring the displayed version always matches the installed package.

### Features

- ✅ Automatic version detection from package.json
- ✅ Color-coded badges based on version:
  - **v1.0.0**: Blue (`text-bg-primary`)
  - **v2.0.0**: Green (`text-bg-success`)
  - **v3.0.0**: Red (`text-bg-danger`)
- ✅ Customizable label text
- ✅ Bootstrap 5 styling
- ✅ Standalone component (no module required)

### Usage

```typescript
import { UiBadgeComponent } from 'shared-ui-v1';

@Component({
  selector: 'app-example',
  standalone: true,
  imports: [UiBadgeComponent],
  template: `
    <shared-ui-badge label="My App"></shared-ui-badge>
  `
})
export class ExampleComponent {}
```

### Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `label` | `string` | `'UI Kit'` | The text label to display before the version |

### Styling

The component uses Bootstrap 5 badge classes:
- `badge` - Base badge styling
- `text-bg-primary` - Blue background (v1.0.0)
- `text-bg-success` - Green background (v2.0.0)
- `text-bg-danger` - Red background (v3.0.0)

### Example Output

```html
<!-- For shared-ui v1.0.0 -->
<span class="badge text-bg-primary">My App v1.0.0</span>

<!-- For shared-ui v2.0.0 -->
<span class="badge text-bg-success">My App v2.0.0</span>

<!-- For shared-ui v3.0.0 -->
<span class="badge text-bg-danger">My App v3.0.0</span>
```

## Syncfusion Grid

**Package:** `@syncfusion/ej2-angular-grids@29.2.11`

### Description

The library includes Syncfusion EJ2 Grid with centralized dependency management through the shell application. This ensures all microfrontends use the same grid version without bundling it multiple times.

### Features

- ✅ Paging
- ✅ Sorting
- ✅ Filtering
- ✅ Grouping
- ✅ Excel export
- ✅ PDF export
- ✅ Bootstrap 5 theme
- ✅ Centrally managed (loaded from shell)

### Usage

```typescript
import { GridModule, PageService, SortService, FilterService } from '@syncfusion/ej2-angular-grids';

@Component({
  selector: 'app-grid-example',
  standalone: true,
  imports: [GridModule],
  providers: [PageService, SortService, FilterService],
  template: `
    <ejs-grid 
      [dataSource]='data' 
      [allowPaging]='true' 
      [allowSorting]='true'
      [allowFiltering]='true'
      [pageSettings]='pageSettings'>
      <e-columns>
        <e-column field='OrderID' headerText='Order ID' width='120'></e-column>
        <e-column field='CustomerName' headerText='Customer Name' width='150'></e-column>
        <e-column field='OrderDate' headerText='Order Date' width='130' format='yMd'></e-column>
        <e-column field='Freight' headerText='Freight' width='120' format='C2'></e-column>
      </e-columns>
    </ejs-grid>
  `
})
export class GridExampleComponent {
  public data: Object[] = [
    { OrderID: 10248, CustomerName: 'Paul Henriot', OrderDate: new Date(8364186e5), Freight: 32.38 },
    { OrderID: 10249, CustomerName: 'Karin Josephs', OrderDate: new Date(836505e6), Freight: 11.61 },
    // ... more data
  ];
  
  public pageSettings: Object = { pageSize: 10 };
}
```

### Theme

The grid uses the Bootstrap 5 theme, which is configured in `angular.json`:

```json
"styles": [
  "node_modules/@syncfusion/ej2-base/styles/bootstrap5.css",
  "node_modules/@syncfusion/ej2-grids/styles/bootstrap5.css"
]
```

### Licensing

**Important:** Syncfusion requires a license for production use.

- **Development**: Free with license banner
- **Production**: Requires license key

Register your license in the shell's `main.ts`:

```typescript
import { registerLicense } from '@syncfusion/ej2-base';

registerLicense('YOUR_LICENSE_KEY_HERE');
```

Get a free community license: https://www.syncfusion.com/products/communitylicense

## Future Components

This section will be updated as new components are added to the library.

### Planned Components

- Button component
- Input component
- Card component
- Modal component
- Navigation component

## Component Development Guidelines

When adding new components to the library:

1. **Create in `libs/shared-ui/src/lib/`**
2. **Use standalone components** (no modules)
3. **Export from `public-api.ts`**
4. **Add JSDoc comments** for Compodoc
5. **Include usage examples** in comments
6. **Follow Bootstrap 5 styling** conventions
7. **Make components version-aware** if needed
8. **Test in multiple MFEs** before releasing

### Example Component Template

```typescript
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

/**
 * A reusable button component with Bootstrap 5 styling.
 * 
 * @example
 * ```html
 * <ui-button label="Click Me" variant="primary"></ui-button>
 * ```
 */
@Component({
  selector: 'ui-button',
  standalone: true,
  imports: [CommonModule],
  template: `
    <button [class]="buttonClass" (click)="handleClick()">
      {{ label }}
    </button>
  `,
  styles: [`
    :host { display: inline-block; }
  `]
})
export class UiButtonComponent {
  /**
   * The button label text
   */
  @Input() label = 'Button';
  
  /**
   * The button variant (primary, secondary, success, danger, etc.)
   */
  @Input() variant: 'primary' | 'secondary' | 'success' | 'danger' = 'primary';
  
  get buttonClass(): string {
    return `btn btn-${this.variant}`;
  }
  
  handleClick(): void {
    // Handle click
  }
}
```

## See Also

- [Getting Started](./getting-started.md)
- [API Documentation](../index.html) (Generated by Compodoc)
- [Syncfusion Integration Guide](../SYNCFUSION_INTEGRATION.md)
