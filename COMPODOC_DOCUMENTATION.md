# Compodoc Documentation Setup

This document explains how to use Compodoc for generating and viewing documentation for the Shared UI component library.

## What is Compodoc?

Compodoc is a documentation tool for Angular applications that automatically generates documentation from your TypeScript code, JSDoc comments, and additional markdown files.

## Installation

Compodoc is already installed as a dev dependency:

```bash
npm install --save-dev @compodoc/compodoc
```

## Configuration

The Compodoc configuration is stored in `.compodocrc.json`:

```json
{
  "name": "Shared UI Component Library",
  "tsconfig": "libs/shared-ui/tsconfig.lib.json",
  "output": "docs/compodoc",
  "theme": "material",
  "includes": "libs/shared-ui/docs",
  "port": 8080,
  "watch": true
}
```

## Available Commands

### Generate Documentation

Generate static documentation files:

```bash
npm run docs:generate
```

This creates documentation in the `docs/compodoc` directory.

### Serve Documentation with Live Reload

Start a development server with live reload (recommended for development):

```bash
npm run docs:serve
```

- Opens at: http://localhost:8080
- Watches for changes in TypeScript files
- Auto-regenerates documentation on changes
- Perfect for component development

### Build Documentation for Production

Build static documentation for deployment:

```bash
npm run docs:build
```

Output: `docs/compodoc/`

### Serve Static Documentation

Serve pre-built documentation without watch mode:

```bash
npm run docs:serve-static
```

## Documentation Structure

```
shared-hub-poc/
├── .compodocrc.json              # Compodoc configuration
├── docs/
│   └── compodoc/                 # Generated documentation (gitignored)
└── libs/
    └── shared-ui/
        ├── docs/                 # Additional markdown docs
        │   ├── getting-started.md
        │   └── components-overview.md
        └── src/
            └── lib/
                └── badge/
                    └── ui-badge.component.ts  # Component with JSDoc
```

## Writing Documentation

### JSDoc Comments

Add comprehensive JSDoc comments to your components:

```typescript
/**
 * Badge component that displays a version badge with automatic color coding.
 * 
 * @example
 * Basic usage:
 * ```html
 * <shared-ui-badge label="My App"></shared-ui-badge>
 * ```
 */
@Component({
  selector: 'shared-ui-badge',
  // ...
})
export class UiBadgeComponent {
  /**
   * The label text to display before the version number.
   * @default 'UI Kit'
   */
  @Input() label = 'UI Kit';
}
```

### Markdown Documentation

Add markdown files in `libs/shared-ui/docs/`:

- `getting-started.md` - Installation and quick start guide
- `components-overview.md` - Detailed component documentation
- Add more as needed

## Features

### Automatic Generation

Compodoc automatically generates:

- **Component Documentation**: All components with their inputs, outputs, and methods
- **API Reference**: Complete TypeScript API documentation
- **Dependency Graph**: Visual representation of component dependencies
- **Coverage Report**: Documentation coverage statistics
- **Search**: Full-text search across all documentation

### Live Examples

Include code examples in JSDoc comments:

```typescript
/**
 * @example
 * ```typescript
 * import { UiBadgeComponent } from 'shared-ui-v1';
 * 
 * @Component({
 *   imports: [UiBadgeComponent],
 *   template: `<shared-ui-badge label="Example"></shared-ui-badge>`
 * })
 * export class ExampleComponent {}
 * ```
 */
```

## Development Workflow

### 1. Start Documentation Server

```bash
npm run docs:serve
```

Opens at http://localhost:8080

### 2. Develop Components

Edit components in `libs/shared-ui/src/lib/`:

```typescript
// libs/shared-ui/src/lib/badge/ui-badge.component.ts
@Component({
  selector: 'shared-ui-badge',
  // ... component code
})
export class UiBadgeComponent {
  // Add JSDoc comments here
}
```

### 3. See Changes Live

Compodoc automatically regenerates documentation when you save files.

### 4. Add Markdown Docs

Create additional documentation in `libs/shared-ui/docs/`:

```markdown
# My Component Guide

Detailed explanation of how to use the component...
```

## Integration with Development

### Parallel Development

Run documentation alongside your development servers:

```bash
# Terminal 1: Documentation
npm run docs:serve

# Terminal 2: Shell app
npm run serve:shell

# Terminal 3: MFE1
npm run serve:mfe1

# Terminal 4: MFE2
npm run serve:mfe2
```

### URLs

- **Compodoc**: http://localhost:8080
- **Shell**: http://localhost:4200
- **MFE1**: http://localhost:4201
- **MFE2**: http://localhost:4202

## Best Practices

### 1. Document Everything

Add JSDoc comments to:
- Components
- Services
- Directives
- Pipes
- Interfaces
- Enums

### 2. Include Examples

Always include usage examples in JSDoc:

```typescript
/**
 * @example
 * ```html
 * <my-component [input]="value"></my-component>
 * ```
 */
```

### 3. Use @default Tags

Document default values:

```typescript
/**
 * The button variant
 * @default 'primary'
 */
@Input() variant: 'primary' | 'secondary' = 'primary';
```

### 4. Add Descriptions

Explain what the component does and when to use it:

```typescript
/**
 * A reusable button component with Bootstrap 5 styling.
 * 
 * Use this component for all button interactions in your application
 * to maintain consistent styling and behavior.
 */
```

### 5. Document Complex Logic

Explain complex getters or methods:

```typescript
/**
 * Returns the Bootstrap badge class based on the version number.
 * 
 * @returns The CSS class string for the badge
 * 
 * Version to class mapping:
 * - '1.0.0' → 'text-bg-primary' (Blue)
 * - '2.0.0' → 'text-bg-success' (Green)
 */
get badgeClass(): string {
  // ...
}
```

## Deployment

### Build for Production

```bash
npm run docs:build
```

### Deploy to GitHub Pages

```bash
# Build documentation
npm run docs:build

# Deploy to gh-pages branch
npx gh-pages -d docs/compodoc
```

### Deploy to Netlify/Vercel

Point your deployment to the `docs/compodoc` directory after running `npm run docs:build`.

## Troubleshooting

### Documentation Not Updating

1. Stop the server (Ctrl+C)
2. Delete `docs/compodoc` directory
3. Run `npm run docs:serve` again

### Missing Components

Ensure components are:
1. Exported from `public-api.ts`
2. Have proper TypeScript types
3. Located in the `libs/shared-ui/src/lib/` directory

### Port Already in Use

Change the port in `.compodocrc.json`:

```json
{
  "port": 8081
}
```

## Additional Resources

- [Compodoc Official Documentation](https://compodoc.app/)
- [JSDoc Reference](https://jsdoc.app/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## Next Steps

1. **Run Documentation**: `npm run docs:serve`
2. **View at**: http://localhost:8080
3. **Explore**: Browse components, API reference, and guides
4. **Develop**: Make changes and see them reflected live
5. **Share**: Deploy documentation for your team

---

**Note**: The documentation is automatically generated from your code. Keep your JSDoc comments up-to-date as you develop!
