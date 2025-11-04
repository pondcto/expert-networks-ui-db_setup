# LLM Mock Backend for Expert Networks Demo

## Overview

This document describes the architecture and implementation plan for an LLM-powered mock backend that simulates expert network vendor behavior. This allows for a realistic demo without requiring actual vendor integrations.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Frontend (Next.js)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Campaigns │  │ Experts  │  │Interviews│  │ Settings │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   API Routes (Next.js)                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  /api/campaigns                                       │  │
│  │  /api/vendors/enroll                                  │  │
│  │  /api/experts/proposed                                │  │
│  │  /api/experts/[id]/screening                          │  │
│  │  /api/interviews/schedule                             │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Database (PostgreSQL)                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  campaigns, experts, interviews, vendor_enrollments   │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              LLM Mock Vendor Service (Background)            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  VendorSimulator                                      │  │
│  │    - Monitors enrolled vendors                        │  │
│  │    - Generates expert profiles                        │  │
│  │    - Creates screening responses                      │  │
│  │    - Simulates realistic delays                       │  │
│  │                                                        │  │
│  │  Uses: Claude/GPT-4 for generation                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Components

### 1. **Vendor Simulator Service**

A background service that:
- Monitors `campaign_vendor_enrollments` table for newly enrolled vendors
- Automatically generates realistic expert proposals
- Creates screening question responses based on expert profiles
- Simulates realistic timing (delays between enrollment and expert proposals)

**Technology Stack:**
- Node.js with TypeScript
- PostgreSQL client (pg)
- Anthropic Claude API or OpenAI GPT-4
- Bull Queue for background job processing

### 2. **Expert Profile Generator**

Uses LLM to generate realistic expert profiles based on:
- Campaign scope (industry, description, screening questions)
- Vendor characteristics (specialization, regions, industries)
- Target expert criteria

**Input:**
```typescript
interface ExpertGenerationRequest {
  campaignId: string;
  vendorId: string;
  campaignDescription: string;
  industryVertical: string;
  screeningQuestions: ScreeningQuestion[];
  targetExpertCount: number; // 5-10 experts per vendor
}
```

**Output:**
```typescript
interface GeneratedExpert {
  name: string;
  title: string;
  company: string;
  description: string;
  workHistory: string;
  skills: string[];
  rating: number; // 3.5 - 5.0
  aiFitScore: number; // 6-10 based on campaign relevance
}
```

### 3. **Screening Response Generator**

Generates contextual responses to screening questions based on expert profile.

**Input:**
```typescript
interface ScreeningResponseRequest {
  expertProfile: GeneratedExpert;
  questions: ScreeningQuestion[];
  campaignContext: string;
}
```

**Output:**
```typescript
interface ScreeningResponse {
  questionId: string;
  responseText: string;
}
```

---

## Implementation Plan

### Phase 1: Database and API Setup

**File: `/lib/db.ts`**
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

export const db = {
  query: (text: string, params?: any[]) => pool.query(text, params),
  getClient: () => pool.connect()
};
```

**File: `/api/vendors/enroll/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';

export async function POST(request: NextRequest) {
  const session = await auth();
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { campaignId, vendorId } = await request.json();

  // Insert enrollment
  await db.query(`
    INSERT INTO campaign_vendor_enrollments (campaign_id, vendor_platform_id, status)
    VALUES ($1, $2, 'pending')
    ON CONFLICT (campaign_id, vendor_platform_id)
    DO UPDATE SET status = 'pending', updated_at = NOW()
  `, [campaignId, vendorId]);

  // Trigger vendor simulator (via queue or webhook)
  await triggerVendorSimulator(campaignId, vendorId);

  return NextResponse.json({ success: true });
}

async function triggerVendorSimulator(campaignId: string, vendorId: string) {
  // Add job to queue (using Bull or similar)
  // OR call vendor simulator webhook
  // OR insert into a jobs table for the simulator to poll
}
```

### Phase 2: Vendor Simulator Service

**File: `/services/vendor-simulator/index.ts`**
```typescript
import Anthropic from '@anthropic-ai/sdk';
import { db } from '@/lib/db';

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

interface CampaignContext {
  id: string;
  campaignName: string;
  industryVertical: string;
  briefDescription: string;
  expandedDescription: string;
  screeningQuestions: Array<{
    id: string;
    text: string;
    subQuestions?: Array<{ id: string; text: string }>;
  }>;
}

interface VendorContext {
  id: string;
  name: string;
  description: string;
  tags: string[];
}

export class VendorSimulator {

  async processEnrollment(campaignId: string, vendorId: string) {
    console.log(`Processing enrollment: Campaign ${campaignId}, Vendor ${vendorId}`);

    // 1. Get campaign context
    const campaign = await this.getCampaignContext(campaignId);
    const vendor = await this.getVendorContext(vendorId);

    // 2. Simulate enrollment delay (2-10 seconds)
    await this.delay(2000 + Math.random() * 8000);

    // 3. Update enrollment status to 'enrolled'
    await db.query(`
      UPDATE campaign_vendor_enrollments
      SET status = 'enrolled', enrolled_at = NOW()
      WHERE campaign_id = $1 AND vendor_platform_id = $2
    `, [campaignId, vendorId]);

    // 4. Generate expert proposals (5-10 experts)
    const expertCount = 5 + Math.floor(Math.random() * 6);

    for (let i = 0; i < expertCount; i++) {
      await this.delay(3000 + Math.random() * 5000); // Simulate staggered expert proposals
      await this.generateAndInsertExpert(campaign, vendor);
    }
  }

  private async generateAndInsertExpert(
    campaign: CampaignContext,
    vendor: VendorContext
  ) {
    const expertProfile = await this.generateExpertProfile(campaign, vendor);

    // Insert expert into database
    const expertResult = await db.query(`
      INSERT INTO experts (
        campaign_id, vendor_platform_id, name, title, company,
        avatar_url, description, work_history, skills,
        rating, ai_fit_score, status, is_new
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'proposed', true)
      RETURNING id
    `, [
      campaign.id,
      vendor.id,
      expertProfile.name,
      expertProfile.title,
      expertProfile.company,
      this.getRandomAvatar(),
      expertProfile.description,
      expertProfile.workHistory,
      expertProfile.skills,
      expertProfile.rating,
      expertProfile.aiFitScore
    ]);

    const expertId = expertResult.rows[0].id;

    // Generate screening responses
    if (campaign.screeningQuestions.length > 0) {
      await this.generateScreeningResponses(
        expertId,
        expertProfile,
        campaign.screeningQuestions
      );
    }
  }

  private async generateExpertProfile(
    campaign: CampaignContext,
    vendor: VendorContext
  ): Promise<any> {

    const prompt = `You are simulating an expert network vendor (${vendor.name}) proposing an expert for a commercial diligence campaign.

Campaign Details:
- Name: ${campaign.campaignName}
- Industry: ${campaign.industryVertical}
- Brief: ${campaign.briefDescription}
- Full Description: ${campaign.expandedDescription}

Vendor Specialization: ${vendor.tags.join(', ')}

Generate a realistic expert profile that would be proposed by this vendor for this campaign.

Return a JSON object with the following structure:
{
  "name": "First Last",
  "title": "Current role and seniority",
  "company": "Current or recent company",
  "description": "2-3 sentence bio highlighting relevant expertise",
  "workHistory": "Detailed paragraph about career progression and relevant experience",
  "skills": ["skill1", "skill2", "skill3", "skill4", "skill5", "skill6"],
  "rating": 4.2,  // Between 3.5 and 5.0
  "aiFitScore": 8  // Between 6 and 10, based on relevance to campaign
}

Make the expert realistic and relevant to the campaign scope. Include industry-specific terminology and authentic career details.`;

    const message = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 2000,
      messages: [{
        role: 'user',
        content: prompt
      }]
    });

    const content = message.content[0];
    if (content.type === 'text') {
      const jsonMatch = content.text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      }
    }

    throw new Error('Failed to parse expert profile from LLM response');
  }

  private async generateScreeningResponses(
    expertId: string,
    expertProfile: any,
    questions: Array<any>
  ) {
    for (const question of questions) {
      const response = await this.generateScreeningResponse(
        expertProfile,
        question
      );

      await db.query(`
        INSERT INTO expert_screening_responses (expert_id, screening_question_id, response_text)
        VALUES ($1, $2, $3)
      `, [expertId, question.id, response]);

      // Handle sub-questions if present
      if (question.subQuestions && question.subQuestions.length > 0) {
        for (const subQuestion of question.subQuestions) {
          const subResponse = await this.generateScreeningResponse(
            expertProfile,
            subQuestion
          );

          await db.query(`
            INSERT INTO expert_screening_responses (expert_id, screening_question_id, response_text)
            VALUES ($1, $2, $3)
          `, [expertId, subQuestion.id, subResponse]);
        }
      }
    }
  }

  private async generateScreeningResponse(
    expertProfile: any,
    question: { id: string; text: string }
  ): Promise<string> {

    const prompt = `You are ${expertProfile.name}, ${expertProfile.title} at ${expertProfile.company}.

Your background: ${expertProfile.description}
Your work history: ${expertProfile.workHistory}
Your skills: ${expertProfile.skills.join(', ')}

Answer this screening question authentically as this expert would:
"${question.text}"

Provide a detailed, professional response (2-4 paragraphs) that demonstrates expertise and specific examples. Be authentic and specific.`;

    const message = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 1000,
      messages: [{
        role: 'user',
        content: prompt
      }]
    });

    const content = message.content[0];
    if (content.type === 'text') {
      return content.text;
    }

    throw new Error('Failed to generate screening response');
  }

  private async getCampaignContext(campaignId: string): Promise<CampaignContext> {
    const result = await db.query(`
      SELECT
        c.*,
        json_agg(
          json_build_object(
            'id', sq.id,
            'text', sq.question_text,
            'subQuestions', (
              SELECT json_agg(
                json_build_object('id', sub.id, 'text', sub.question_text)
              )
              FROM screening_questions sub
              WHERE sub.parent_question_id = sq.id
            )
          )
        ) FILTER (WHERE sq.id IS NOT NULL) as screening_questions
      FROM campaigns c
      LEFT JOIN screening_questions sq ON sq.campaign_id = c.id AND sq.parent_question_id IS NULL
      WHERE c.id = $1
      GROUP BY c.id
    `, [campaignId]);

    return result.rows[0];
  }

  private async getVendorContext(vendorId: string): Promise<VendorContext> {
    const result = await db.query(`
      SELECT id, name, description, tags
      FROM vendor_platforms
      WHERE id = $1
    `, [vendorId]);

    return result.rows[0];
  }

  private getRandomAvatar(): string {
    const avatars = [
      '/images/avatar/John Robert.png',
      '/images/avatar/Michael David.png',
      '/images/avatar/David Charles.png',
      '/images/avatar/Christopher Mark.png',
      '/images/avatar/Daniel Paul.png',
      '/images/avatar/James William.png',
      '/images/avatar/Matthew Scott.png',
      '/images/avatar/Richard Alan.png',
      '/images/avatar/Robert James.png',
      '/images/avatar/Thomas Edward.png'
    ];

    return avatars[Math.floor(Math.random() * avatars.length)];
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// Export singleton instance
export const vendorSimulator = new VendorSimulator();
```

### Phase 3: Background Job Processor

**File: `/services/vendor-simulator/worker.ts`**
```typescript
import { vendorSimulator } from './index';
import { db } from '@/lib/db';

async function processPendingEnrollments() {
  console.log('Checking for pending vendor enrollments...');

  const result = await db.query(`
    SELECT campaign_id, vendor_platform_id
    FROM campaign_vendor_enrollments
    WHERE status = 'pending'
    ORDER BY created_at ASC
    LIMIT 5
  `);

  for (const enrollment of result.rows) {
    try {
      await vendorSimulator.processEnrollment(
        enrollment.campaign_id,
        enrollment.vendor_platform_id
      );
    } catch (error) {
      console.error('Error processing enrollment:', error);

      // Mark as failed (optional)
      await db.query(`
        UPDATE campaign_vendor_enrollments
        SET status = 'not_enrolled', updated_at = NOW()
        WHERE campaign_id = $1 AND vendor_platform_id = $2
      `, [enrollment.campaign_id, enrollment.vendor_platform_id]);
    }
  }
}

// Run every 10 seconds
setInterval(processPendingEnrollments, 10000);

// Initial run
processPendingEnrollments();
```

### Phase 4: Integration with Frontend

**File: `/api/vendors/enroll/route.ts`** (updated)
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function POST(request: NextRequest) {
  const session = await getServerSession(authOptions);
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

## Environment Variables

Add to `.env.local`:

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/expert_networks

# BetterAuth
BETTER_AUTH_SECRET=your-secret-key
BETTER_AUTH_URL=http://localhost:3000

# LLM API
ANTHROPIC_API_KEY=your-anthropic-api-key
# OR

# Optional: Background job processing
REDIS_URL=redis://localhost:6379
```

---

## Running the Demo

### 1. Start PostgreSQL
```bash
# Using Docker
docker run --name expert-networks-db -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:15

# Apply schema
psql -h localhost -U postgres -d expert_networks < schema.sql
psql -h localhost -U postgres -d expert_networks < seed_data.sql
```

### 2. Start the Background Worker
```bash
# In a separate terminal
npx tsx services/vendor-simulator/worker.ts
```

### 3. Start Next.js Development Server
```bash
npm run dev
```

### 4. Test the Flow
1. Create a new campaign with screening questions
2. Enroll a vendor (e.g., GLG)
3. Watch the background worker process the enrollment
4. See experts appear in the UI within 10-30 seconds
5. Review expert profiles and screening responses

---

## Advanced Features

### Real-time Updates

Use Pusher or Server-Sent Events to push updates to the frontend:

**File: `/lib/pusher.ts`**
```typescript
import Pusher from 'pusher';

export const pusher = new Pusher({
  appId: process.env.PUSHER_APP_ID!,
  key: process.env.PUSHER_KEY!,
  secret: process.env.PUSHER_SECRET!,
  cluster: process.env.PUSHER_CLUSTER!,
});

export function notifyNewExpert(userId: string, campaignId: string, expert: any) {
  pusher.trigger(`private-user-${userId}`, 'new-expert', {
    campaignId,
    expert
  });
}
```

### Vendor-Specific Behavior

Customize expert generation based on vendor characteristics:

```typescript
private getVendorBehaviorProfile(vendor: VendorContext) {
  const profiles: Record<string, any> = {
    'GLG': {
      expertCount: [8, 12],  // Higher volume
      qualityScore: [8, 10],  // Higher quality
      responseDelay: [5000, 15000],  // Slower but thorough
    },
    'AlphaSights': {
      expertCount: [6, 10],
      qualityScore: [8, 10],
      responseDelay: [3000, 10000],
    },
    'Inex One': {
      expertCount: [15, 20],  // High volume aggregator
      qualityScore: [6, 9],  // Variable quality
      responseDelay: [2000, 8000],  // Fast
    }
  };

  return profiles[vendor.name] || {
    expertCount: [5, 10],
    qualityScore: [6, 9],
    responseDelay: [3000, 12000],
  };
}
```

---

## Testing

### Unit Tests

```typescript
// services/vendor-simulator/__tests__/expert-generator.test.ts
import { VendorSimulator } from '../index';

describe('VendorSimulator', () => {
  it('should generate expert profile with correct structure', async () => {
    const simulator = new VendorSimulator();
    const campaign = { /* mock campaign */ };
    const vendor = { /* mock vendor */ };

    const expert = await simulator.generateExpertProfile(campaign, vendor);

    expect(expert).toHaveProperty('name');
    expect(expert).toHaveProperty('title');
    expect(expert).toHaveProperty('aiFitScore');
    expect(expert.aiFitScore).toBeGreaterThanOrEqual(6);
    expect(expert.aiFitScore).toBeLessThanOrEqual(10);
  });
});
```

### Integration Tests

```typescript
// __tests__/api/vendors/enroll.test.ts
import { POST } from '@/api/vendors/enroll/route';

describe('POST /api/vendors/enroll', () => {
  it('should enroll vendor and trigger expert generation', async () => {
    // Mock session, database, etc.
    const request = new Request('http://localhost:3000/api/vendors/enroll', {
      method: 'POST',
      body: JSON.stringify({
        campaignId: 'campaign-123',
        vendorId: 'vendor-456'
      })
    });

    const response = await POST(request);
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(data.success).toBe(true);
  });
});
```

---

## Monitoring and Debugging

### Logging

Add structured logging:

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'vendor-simulator.log' }),
    new winston.transports.Console()
  ]
});

// Usage
logger.info('Expert generated', {
  campaignId,
  vendorId,
  expertId,
  aiFitScore: expert.aiFitScore
});
```

### Dashboard

Create an admin dashboard to monitor:
- Enrollment queue status
- Expert generation metrics
- LLM API usage and costs
- Error rates

---

## Cost Optimization

### Rate Limiting

```typescript
private rateLimiter = {
  tokens: 100,
  maxTokens: 100,
  refillRate: 10, // tokens per second
  lastRefill: Date.now()
};

private async checkRateLimit() {
  const now = Date.now();
  const elapsed = (now - this.rateLimiter.lastRefill) / 1000;
  this.rateLimiter.tokens = Math.min(
    this.rateLimiter.maxTokens,
    this.rateLimiter.tokens + elapsed * this.rateLimiter.refillRate
  );
  this.rateLimiter.lastRefill = now;

  if (this.rateLimiter.tokens < 1) {
    await this.delay(1000);
    return this.checkRateLimit();
  }

  this.rateLimiter.tokens -= 1;
}
```

### Caching

Cache generated responses for common questions:

```typescript
private responseCache = new Map<string, string>();

private getCacheKey(expertProfile: any, question: string): string {
  return `${expertProfile.title}-${question}`.slice(0, 100);
}
```

---

## Production Considerations

1. **Queue System**: Use Bull, BullMQ, or AWS SQS for robust job processing
2. **Database Connection Pooling**: Properly configure pg pool
3. **Error Handling**: Implement retry logic with exponential backoff
4. **Monitoring**: Use Sentry or similar for error tracking
5. **Scaling**: Run multiple worker instances
6. **LLM Fallback**: Support both Claude and GPT-4 with automatic fallback

---

## Future Enhancements

1. **Interview Scheduling Simulation**: Auto-accept interview requests
2. **Transcript Generation**: Generate realistic interview transcripts
3. **Vendor Messaging**: Simulate email/message exchanges with account managers
4. **Cost Calculation**: Realistic pricing based on vendor and expert
5. **Calendar Integration**: Generate calendar events for interviews
6. **Compliance Simulation**: Simulate conflict checks and compliance holds

---

## Conclusion

This LLM mock backend provides a realistic, fully automated demo experience for the Expert Networks platform. Users can interact with the system as if real vendors were responding, making it ideal for product demonstrations, investor presentations, and internal testing.
