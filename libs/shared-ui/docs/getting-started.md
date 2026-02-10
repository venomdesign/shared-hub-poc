# Getting Started

Welcome to the **Shared UI Component Library** documentation!

This library provides reusable Angular components for building consistent user interfaces across multiple microfrontend applications.

## Installation

The library is available in multiple versions to support version independence across microfrontends:

```bash
# Install version 1.0.0 (Blue badge)
npm install shared-ui-v1

# Install version 2.0.0 (Green badge)
npm install shared-ui-v2

# Install version 3.0.0 (Red badge)
npm install shared-ui-v3
```

## Quick Start

### Importing Components

```typescript
import { UiBadgeComponent } from 'shared-ui-v1';

@Component({
  selector: 'app-my-component',
  standalone: true,
  imports: [UiBadgeComponent],
  template: `
    <shared-ui-badge label="My App"></shared-ui-badge>
  `
})
export class MyComponent {}
```

### Using with Module Federation

The library is designed to work seamlessly with Angular Native Federation for microfrontend architectures.

**Shell Configuration:**
```javascript
// federation.config.js
shared: {
  'shared-ui-v1': {
    singleton: false,
    strictVersion: false,
    requiredVersion: '1.0.0',
  }
}
```

## Available Components

### Badge Component

Display version badges with automatic color coding based on version number.

**Features:**
- Automatic version detection from package.json
- Color-coded badges (Blue=v1, Green=v2, Red=v3)
- Customizable label
- Bootstrap 5 styling

**Example:**
```html
<shared-ui-badge label="Shared UI"></shared-ui-badge>
```

### Syncfusion Grid Integration

The library includes Syncfusion EJ2 Grid (v29.2.11) with Bootstrap 5 theme.

**Features:**
- Paging
- Sorting
- Filtering
- Excel/PDF export
- Bootstrap 5 theme

**Example:**
```typescript
import { GridModule } from '@syncfusion/ej2-angular-grids';

@Component({
  imports: [GridModule],
  template: `
    <ejs-grid [dataSource]='data' [allowPaging]='true'>
      <e-columns>
        <e-column field='OrderID' headerText='Order ID'></e-column>
        <e-column field='CustomerName' headerText='Customer'></e-column>
      </e-columns>
    </ejs-grid>
  `
})
```

## Architecture

### Version Independence

Each microfrontend can use a different version of the shared-ui library:

```
┌─────────────────────────────────────────┐
│              Shell (Host)                │
│  Controls: Syncfusion v29.2.11          │
└─────────────────────────────────────────┘
           │                │
    ┌──────┘                └──────┐
    │                              │
┌───▼────────┐              ┌─────▼──────┐
│   MFE1     │              │   MFE2     │
│ shared-ui  │              │ shared-ui  │
│   v1.0.0   │              │   v2.0.0   │
└────────────┘              └────────────┘
```

### Central Dependency Management

The shell application centrally manages shared dependencies like Syncfusion, reducing bundle sizes by 67%.

## Development

### Hot Module Replacement

When developing components, changes are immediately reflected in consuming applications without rebuilding:

```bash
# Terminal 1: Watch shared-ui changes
npm run build:shared-ui -- --watch

# Terminal 2: Run your app
npm run serve:mfe1
```

### Adding New Components

1. Create component in `libs/shared-ui/src/lib/`
2. Export from `libs/shared-ui/src/public-api.ts`
3. Build versions: `bash scripts/build-all-shared-ui-versions.sh`
4. Document with JSDoc comments for Compodoc

## Live Examples

Visit the showcase applications to see live component demos:

- **MFE1**: http://localhost:4201 (Uses shared-ui v1.0.0)
- **MFE2**: http://localhost:4202 (Uses shared-ui v2.0.0)
- **Shell**: http://localhost:4200 (Host application)

## Resources

- [Syncfusion Integration Guide](../SYNCFUSION_INTEGRATION.md)
- [Version Management](../VERSION_MANAGEMENT.md)
- [Central Dependency Management](../CENTRAL_DEPENDENCY_MANAGEMENT.md)
- [Badge Fix Summary](../BADGE_FIX_SUMMARY.md)

## Support

For issues or questions, please refer to the project documentation or contact the development team.
