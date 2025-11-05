# Expert Networks UI - React Application

A modern React application built with Vite, TypeScript, and Tailwind CSS.

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📁 Project Structure

```
src/
├── components/     # Reusable UI components
├── pages/          # Route pages (lazy-loaded)
├── hooks/          # Custom React hooks
├── lib/            # Core libraries & utilities
├── utils/          # Utility functions
├── types/          # TypeScript definitions
├── providers/      # Context providers
└── App.tsx         # Main application
```

## 🎯 Features

- ⚡ **Fast**: Vite build tool for instant HMR
- 📦 **Optimized**: Code splitting & lazy loading
- 🎨 **Modern UI**: Tailwind CSS with custom design system
- 🔒 **Type Safe**: Full TypeScript support
- 🧩 **Component Library**: Reusable UI components
- 🎭 **Dark Mode**: Built-in theme support

## 📚 Documentation

- [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - Detailed project structure
- [OPTIMIZATION_GUIDE.md](./OPTIMIZATION_GUIDE.md) - Performance optimizations
- [REACT_OPTIMIZATION_SUMMARY.md](./REACT_OPTIMIZATION_SUMMARY.md) - Optimization summary

## 🛠️ Tech Stack

- **React 19** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool
- **React Router** - Routing
- **Tailwind CSS** - Styling
- **Zustand** - State management
- **Radix UI** - Component primitives

## 🔧 Configuration

### Environment Variables

Create `.env` file:
```env
VITE_APP_URL=http://localhost:3010
VITE_API_BASE=/api
```

### Path Aliases

Use `@/` prefix for imports:
```tsx
import { Button } from '@/components';
import { useApi } from '@/hooks';
import { authHeaders } from '@/lib';
```

## 📦 Build Output

The build creates optimized chunks:
- `react-vendor.js` - React core
- `ui-vendor.js` - UI libraries
- `workspace.js` - Workspace features
- Route-specific chunks

## 🎨 Styling

- Tailwind CSS for utility-first styling
- Custom design system with light/dark themes
- Responsive design built-in

## 🚦 Development

```bash
# Run dev server
npm run dev

# Lint code
npm run lint

# Type check
npx tsc --noEmit
```

## 📝 Best Practices

1. Use barrel exports for cleaner imports
2. Lazy load heavy components
3. Use React.memo for expensive components
4. Keep components small and focused
5. Type everything with TypeScript

## 🔗 Related

- Backend API: See `backend/` directory
- Migration Guide: See `MIGRATION_GUIDE.md`
