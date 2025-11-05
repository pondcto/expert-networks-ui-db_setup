#!/bin/bash

# Remove "use client" directives
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/^[\"']use client[\"'];$//g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/^\"use client\"$//g" {} \;

# Replace Next.js navigation imports
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/from ['\"]next\/navigation['\"]/from 'react-router-dom'/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/useRouter/useNavigate/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/usePathname/useLocation/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/const router = useNavigate()/const navigate = useNavigate()/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/router\.push(/navigate(/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/router\.replace(/navigate(..., { replace: true })/g" {} \;

# Replace Next.js Link imports
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/from ['\"]next\/link['\"]/from 'react-router-dom'/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/<Link href=/<Link to=/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/href=\"/to=\"/g" {} \;

# Replace environment variables
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/process\.env\.NEXT_PUBLIC_/import.meta.env.VITE_/g" {} \;

# Replace useLocation().pathname for usePathname
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/const pathname = useLocation()/const location = useLocation()/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/pathname ===/location.pathname ===/g" {} \;
find src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i "s/pathname\./location.pathname./g" {} \;

echo "Files updated. Please review and fix any remaining issues manually."

