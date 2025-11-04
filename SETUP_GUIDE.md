# Expert Networks Platform - Setup Guide

## Quick Start

This guide will help you set up the Expert Networks platform with PostgreSQL database, BetterAuth integration, and the LLM mock backend for realistic vendor simulation.

---

## Prerequisites

- Node.js 18+ and npm
- PostgreSQL 14+
- Git
- Anthropic API key (for LLM mock backend)

---

## Step 1: Database Setup

### Install PostgreSQL

**Option A: Using Docker (Recommended)**
```bash
docker run --name expert-networks-db \
  -e POSTGRES_PASSWORD=your_password \
  -e POSTGRES_DB=expert_networks \
  -p 5432:5432 \
  -d postgres:15

# Verify it's running
docker ps
```

**Option B: Native Installation**
- Download from [postgresql.org](https://www.postgresql.org/download/)
- Create a database named `expert_networks`

### Apply Database Schema

```bash
# Connect to PostgreSQL
psql -h localhost -U postgres -d expert_networks

# Or if using Docker
docker exec -i expert-networks-db psql -U postgres -d expert_networks < schema.sql

# Apply the schema
\i schema.sql

# Apply seed data (vendor platforms)
\i seed_data.sql

# Verify tables were created
\dt

# Exit
\q
```

---

## Step 2: Install Dependencies

```bash
# Install project dependencies
npm install

# Install additional packages for database and LLM integration
npm install pg @types/pg
npm install @anthropic-ai/sdk
npm install winston  # For logging

# Install BetterAuth (if not already installed)
npm install better-auth
```

---

## Step 3: Environment Configuration

Create a `.env.local` file in the project root:

```bash
# Database
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/expert_networks

# BetterAuth Configuration
BETTER_AUTH_SECRET=your-random-secret-here-min-32-chars
BETTER_AUTH_URL=http://localhost:3000
NEXTAUTH_URL=http://localhost:3000

# LLM API (choose one or both for fallback)
ANTHROPIC_API_KEY=sk-ant-your-key-here

# Optional: For real-time updates
PUSHER_APP_ID=your-pusher-app-id
PUSHER_KEY=your-pusher-key
PUSHER_SECRET=your-pusher-secret
PUSHER_CLUSTER=us2

# Development
NODE_ENV=development
```

Generate a secure secret for BETTER_AUTH_SECRET:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## Step 4: BetterAuth Setup

### Create BetterAuth Configuration

**File: `/lib/auth.ts`** (if not exists)
```typescript
import { betterAuth } from "better-auth";
import { Pool } from "pg";

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const auth = betterAuth({
  database: {
    provider: "postgres",
    pool: pool,
  },
  emailAndPassword: {
    enabled: true,
  },
  socialProviders: {
    // Add social providers if needed
    // google: {
    //   clientId: process.env.GOOGLE_CLIENT_ID,
    //   clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    // },
  },
});

export type Session = typeof auth.$Infer.Session;
```

### Create BetterAuth Tables

BetterAuth will automatically create its tables on first run. To manually create them:

```bash
# Start the dev server once to initialize BetterAuth tables
npm run dev

# Wait for BetterAuth to create tables, then stop the server (Ctrl+C)
```

---

## Step 5: Database Library Setup

**File: `/lib/db.ts`**
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Test connection on startup
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('Database connection error:', err);
  } else {
    console.log('Database connected successfully at', res.rows[0].now);
  }
});

export const db = {
  query: (text: string, params?: any[]) => pool.query(text, params),
  getClient: () => pool.connect(),
  pool,
};

export default db;
```

---

## Step 6: API Routes Setup

### Create Campaign API Routes

**File: `/app/api/campaigns/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';
import { headers } from 'next/headers';

export async function GET(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: await headers()
  });

  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const result = await db.query(`
    SELECT c.*, p.project_name, p.project_code
    FROM campaigns c
    LEFT JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = $1
    ORDER BY c.created_at DESC
  `, [session.user.id]);

  return NextResponse.json({ campaigns: result.rows });
}

export async function POST(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: await headers()
  });

  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const data = await request.json();

  const result = await db.query(`
    INSERT INTO campaigns (
      user_id, project_id, campaign_name, industry_vertical,
      brief_description, expanded_description, start_date,
      target_completion_date, target_regions, min_calls, max_calls
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
    RETURNING *
  `, [
    session.user.id,
    data.projectId || null,
    data.campaignName,
    data.industryVertical,
    data.briefDescription,
    data.expandedDescription,
    data.startDate,
    data.targetCompletionDate,
    data.targetRegions,
    data.minCalls,
    data.maxCalls
  ]);

  return NextResponse.json({ campaign: result.rows[0] }, { status: 201 });
}
```

**File: `/app/api/campaigns/[id]/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';
import { headers } from 'next/headers';

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const session = await auth.api.getSession({
    headers: await headers()
  });

  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const result = await db.query(`
    SELECT c.*, p.project_name
    FROM campaigns c
    LEFT JOIN projects p ON c.project_id = p.id
    WHERE c.id = $1 AND c.user_id = $2
  `, [params.id, session.user.id]);

  if (result.rows.length === 0) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }

  return NextResponse.json({ campaign: result.rows[0] });
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const session = await auth.api.getSession({
    headers: await headers()
  });

  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const data = await request.json();

  // Build dynamic update query
  const updates: string[] = [];
  const values: any[] = [];
  let paramCount = 1;

  Object.entries(data).forEach(([key, value]) => {
    updates.push(`${key} = $${paramCount}`);
    values.push(value);
    paramCount++;
  });

  values.push(params.id, session.user.id);

  const result = await db.query(`
    UPDATE campaigns
    SET ${updates.join(', ')}, updated_at = NOW()
    WHERE id = $${paramCount} AND user_id = $${paramCount + 1}
    RETURNING *
  `, values);

  if (result.rows.length === 0) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }

  return NextResponse.json({ campaign: result.rows[0] });
}
```

### Create Vendor Enrollment API

**File: `/app/api/vendors/enroll/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';
import { headers } from 'next/headers';

export async function POST(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: await headers()
  });

  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { campaignId, vendorId } = await request.json();

  // Verify campaign belongs to user
  const campaignCheck = await db.query(
    'SELECT id FROM campaigns WHERE id = $1 AND user_id = $2',
    [campaignId, session.user.id]
  );

  if (campaignCheck.rows.length === 0) {
    return NextResponse.json({ error: 'Campaign not found' }, { status: 404 });
  }

  // Insert enrollment
  await db.query(`
    INSERT INTO campaign_vendor_enrollments (campaign_id, vendor_platform_id, status)
    VALUES ($1, $2, 'pending')
    ON CONFLICT (campaign_id, vendor_platform_id)
    DO UPDATE SET status = 'pending', updated_at = NOW()
  `, [campaignId, vendorId]);

  return NextResponse.json({
    success: true,
    message: 'Vendor enrollment initiated. Experts will be proposed shortly.'
  });
}
```

---

## Step 7: LLM Mock Backend Setup

### Create Vendor Simulator Service

Create the directory structure:
```bash
mkdir -p services/vendor-simulator
```

Copy the VendorSimulator class from `LLM_MOCK_BACKEND.md` into:
**File: `/services/vendor-simulator/index.ts`**

### Create Background Worker

**File: `/services/vendor-simulator/worker.ts`**

```typescript
import { vendorSimulator } from './index';
import db from '@/lib/db';

async function processPendingEnrollments() {
  console.log('[Worker] Checking for pending vendor enrollments...');

  try {
    const result = await db.query(`
      SELECT campaign_id, vendor_platform_id
      FROM campaign_vendor_enrollments
      WHERE status = 'pending'
      ORDER BY created_at ASC
      LIMIT 5
    `);

    console.log(`[Worker] Found ${result.rows.length} pending enrollments`);

    for (const enrollment of result.rows) {
      try {
        console.log(`[Worker] Processing: Campaign ${enrollment.campaign_id}, Vendor ${enrollment.vendor_platform_id}`);
        await vendorSimulator.processEnrollment(
          enrollment.campaign_id,
          enrollment.vendor_platform_id
        );
        console.log(`[Worker] Successfully processed enrollment`);
      } catch (error) {
        console.error('[Worker] Error processing enrollment:', error);

        // Mark as failed
        await db.query(`
          UPDATE campaign_vendor_enrollments
          SET status = 'not_enrolled', updated_at = NOW()
          WHERE campaign_id = $1 AND vendor_platform_id = $2
        `, [enrollment.campaign_id, enrollment.vendor_platform_id]);
      }
    }
  } catch (error) {
    console.error('[Worker] Error in processPendingEnrollments:', error);
  }
}

// Run every 10 seconds
console.log('[Worker] Starting vendor simulator worker...');
setInterval(processPendingEnrollments, 10000);

// Initial run
processPendingEnrollments();
```

### Add Worker Script to package.json

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "worker": "tsx watch services/vendor-simulator/worker.ts",
    "dev:all": "concurrently \"npm run dev\" \"npm run worker\""
  }
}
```

Install concurrently and tsx:
```bash
npm install -D concurrently tsx
```

---

## Step 8: Update Frontend to Use Database

### Update Campaign Context

**File: `/app/lib/campaign-context.tsx`** (modify to use API)

```typescript
'use client';

import { createContext, useContext, useState, useEffect } from 'react';

interface CampaignContextType {
  campaignData: any;
  saveCampaign: (data: any) => Promise<void>;
  isNewCampaign: boolean;
}

const CampaignContext = createContext<CampaignContextType | undefined>(undefined);

export function CampaignProvider({ children, campaignId }: { children: React.ReactNode; campaignId?: string }) {
  const [campaignData, setCampaignData] = useState<any>(null);
  const isNewCampaign = campaignId === 'new';

  useEffect(() => {
    if (!isNewCampaign && campaignId) {
      fetchCampaign(campaignId);
    }
  }, [campaignId, isNewCampaign]);

  async function fetchCampaign(id: string) {
    const res = await fetch(`/api/campaigns/${id}`);
    const data = await res.json();
    setCampaignData(data.campaign);
  }

  async function saveCampaign(data: any) {
    if (isNewCampaign) {
      const res = await fetch('/api/campaigns', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      const result = await res.json();
      setCampaignData(result.campaign);
      // Redirect to the new campaign
      window.location.href = `/campaign/${result.campaign.id}/settings`;
    } else {
      const res = await fetch(`/api/campaigns/${campaignId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      const result = await res.json();
      setCampaignData(result.campaign);
    }
  }

  return (
    <CampaignContext.Provider value={{ campaignData, saveCampaign, isNewCampaign }}>
      {children}
    </CampaignContext.Provider>
  );
}

export function useCampaign() {
  const context = useContext(CampaignContext);
  if (!context) {
    throw new Error('useCampaign must be used within CampaignProvider');
  }
  return context;
}
```

---

## Step 9: Testing

### Start All Services

```bash
# Terminal 1: Start PostgreSQL (if using Docker)
docker start expert-networks-db

# Terminal 2: Start the worker
npm run worker

# Terminal 3: Start Next.js dev server
npm run dev

# OR use concurrently to start both worker and dev server
npm run dev:all
```

### Test the Flow

1. **Sign up / Sign in** (BetterAuth will create tables on first use)
2. **Create a new project**
3. **Create a new campaign** with:
   - Campaign details
   - Screening questions
   - Team members
4. **Enroll a vendor** (e.g., GLG)
5. **Watch the worker logs** - should show enrollment processing
6. **Wait 10-30 seconds** - experts should appear in the UI
7. **Review expert profiles** - click on experts to see details
8. **Check screening responses** - generated based on campaign questions

### Verify Database

```bash
psql -h localhost -U postgres -d expert_networks

-- Check campaigns
SELECT * FROM campaigns;

-- Check enrollments
SELECT * FROM campaign_vendor_enrollments;

-- Check experts
SELECT name, title, status FROM experts;

-- Check screening responses
SELECT * FROM expert_screening_responses LIMIT 5;
```

---

## Step 10: Deployment

### Deploy to Vercel

1. **Push to GitHub**
```bash
git add .
git commit -m "Add database integration and LLM mock backend"
git push origin main
```

2. **Deploy on Vercel**
   - Import your GitHub repository
   - Add environment variables in Vercel dashboard
   - Deploy

3. **Setup PostgreSQL on Vercel**
   - Use Vercel Postgres or Neon
   - Update DATABASE_URL environment variable

4. **Deploy Worker Separately**
   - Use Vercel Cron Jobs or deploy worker to separate service (Railway, Render, etc.)

### Alternative: Deploy to Railway

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Add PostgreSQL
railway add postgresql

# Deploy
railway up
```

---

## Troubleshooting

### Database Connection Issues

```bash
# Test connection
psql -h localhost -U postgres -d expert_networks -c "SELECT NOW()"

# Check if Docker is running
docker ps

# View Docker logs
docker logs expert-networks-db
```

### LLM API Issues

```bash
# Test Anthropic API
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":1024,"messages":[{"role":"user","content":"Hello"}]}'
```

### Worker Not Processing

```bash
# Check worker logs
npm run worker

# Manually trigger enrollment in database
psql -h localhost -U postgres -d expert_networks -c \
  "UPDATE campaign_vendor_enrollments SET status = 'pending' WHERE status = 'not_enrolled'"
```

---

## Next Steps

1. **Frontend Integration**: Update all components to use API routes instead of localStorage
2. **Real-time Updates**: Implement Pusher or SSE for live expert updates
3. **Interview Scheduling**: Add interview scheduling endpoints and UI
4. **Transcript Generation**: Extend LLM backend to generate interview transcripts
5. **Analytics**: Add dashboards and reporting features
6. **Mobile**: Create responsive layouts for mobile devices

---

## Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [BetterAuth Documentation](https://www.better-auth.com/docs)
- [Anthropic API Documentation](https://docs.anthropic.com/)
- [Next.js API Routes](https://nextjs.org/docs/api-routes/introduction)
- [Vercel Deployment](https://vercel.com/docs)

---

## Support

For questions or issues:
1. Check the troubleshooting section
2. Review the database schema documentation
3. Check the LLM mock backend guide
4. Review Next.js and PostgreSQL documentation
