#!/bin/bash

# Create directories
mkdir -p src/pages/campaign src/pages/project src/components src/lib src/hooks src/types src/utils src/data src/providers

# Copy files from app to src
cp -r app/components/* src/components/ 2>/dev/null || true
cp -r app/lib/* src/lib/ 2>/dev/null || true
cp -r app/hooks/* src/hooks/ 2>/dev/null || true
cp -r app/types/* src/types/ 2>/dev/null || true
cp -r app/utils/* src/utils/ 2>/dev/null || true
cp -r app/data/* src/data/ 2>/dev/null || true
cp -r app/providers/* src/providers/ 2>/dev/null || true

# Copy pages
mkdir -p src/pages/campaign/\[campaign_id\] src/pages/project/\[project_code\]
cp app/page.tsx src/pages/Home.tsx 2>/dev/null || true
cp app/login/page.tsx src/pages/Login.tsx 2>/dev/null || true
cp app/signup/page.tsx src/pages/Signup.tsx 2>/dev/null || true
cp app/campaign/new/page.tsx src/pages/campaign/New.tsx 2>/dev/null || true
cp app/campaign/\[campaign_id\]/page.tsx src/pages/campaign/\[campaign_id\]/index.tsx 2>/dev/null || true
cp app/campaign/\[campaign_id\]/settings/page.tsx src/pages/campaign/\[campaign_id\]/settings.tsx 2>/dev/null || true
cp app/campaign/\[campaign_id\]/experts/page.tsx src/pages/campaign/\[campaign_id\]/experts.tsx 2>/dev/null || true
cp app/campaign/\[campaign_id\]/interviews/page.tsx src/pages/campaign/\[campaign_id\]/interviews.tsx 2>/dev/null || true
cp app/project/\[project_code\]/page.tsx src/pages/project/\[project_code\]/index.tsx 2>/dev/null || true

echo "Files copied. Now run find-and-replace for Next.js to React Router migration."

