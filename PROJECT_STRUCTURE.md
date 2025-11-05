# React Project Structure

This is a **React application** using:
- **Vite** as the build tool
- **React Router** for routing
- **TypeScript** for type safety
- **Tailwind CSS** for styling

## Project Structure

```
├── src/                    # ✅ ACTIVE React application code
│   ├── main.tsx           # Application entry point
│   ├── App.tsx            # Main app component with routing
│   ├── index.css          # Global styles
│   ├── pages/             # Page components
│   │   ├── Home.tsx
│   │   ├── Login.tsx
│   │   ├── Signup.tsx
│   │   ├── campaign/
│   │   └── project/
│   ├── components/        # React components
│   ├── lib/               # Utilities and helpers
│   ├── hooks/             # Custom React hooks
│   ├── providers/         # Context providers
│   ├── types/             # TypeScript types
│   └── utils/             # Utility functions
│
├── app/                    # ⚠️ LEGACY Next.js directory (NOT USED)
│   └── ...                # Old Next.js files - can be ignored/deleted
│
├── public/                 # Static assets
├── index.html             # HTML entry point
├── vite.config.ts         # Vite configuration
├── tsconfig.json          # TypeScript config (only includes src/)
├── tailwind.config.ts     # Tailwind configuration
└── package.json           # Dependencies

```

## Important Notes

1. **Only `src/` directory is used** - This is where all active React code lives
2. **`app/` directory is legacy** - Contains old Next.js code that is NOT used
3. **No Next.js dependencies** - All Next.js packages have been removed
4. **TypeScript config** - Only includes `src/` directory (see `tsconfig.json`)
5. **Vite config** - Only processes `src/` directory

## Entry Point Flow

```
index.html
  └── /src/main.tsx
      └── <BrowserRouter>
          └── <App />
              └── <Routes> (React Router)
```

## Build Commands

- `npm run dev` - Start development server (Vite)
- `npm run build` - Build for production (Vite)
- `npm run preview` - Preview production build

## Routing

All routing is handled by **React Router** in `src/App.tsx`:
- Client-side routing (no server-side rendering)
- Dynamic routes with `:param` syntax
- Lazy loading for code splitting

## Environment Variables

Use `VITE_*` prefix for environment variables:
- `VITE_API_BASE` - API base URL
- `VITE_APP_URL` - Application URL
- Access via `import.meta.env.VITE_*`

