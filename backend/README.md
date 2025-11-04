# Expert Networks Backend

FastAPI REST API for the Expert Networks commercial diligence application.

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Run database migrations
cd migrations
python run_migrations.py
cd ..

# Start development server
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Or use Python directly
python main.py
```

The API will be available at http://localhost:8000

- **Interactive Docs**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc

## Project Structure

```
backend/
├── main.py                      # FastAPI application entry point
├── db.py                        # Database utilities and connection pooling
├── requirements.txt             # Python dependencies
├── .env                         # Environment variables (create this)
│
├── api/                         # API routers organized by domain
│   ├── campaigns.py             # Campaign CRUD + vendor enrollment
│   ├── experts.py               # Expert management + screening
│   ├── interviews.py            # Interview scheduling + notes
│   ├── projects.py              # Project management
│   └── vendors.py               # Vendor platform endpoints
│
├── models/                      # Pydantic models for validation
│   ├── campaign.py              # Campaign schemas
│   ├── expert.py                # Expert schemas
│   ├── interview.py             # Interview schemas
│   ├── project.py               # Project schemas
│   ├── vendor.py                # Vendor schemas
│   └── common.py                # Shared models (responses, pagination)
│
├── auth/                        # Authentication
│   └── better_auth.py           # BetterAuth session validation
│
└── migrations/                  # Database migrations
    ├── run_migrations.py        # Migration runner
    ├── 001_create_expert_network_schema.sql
    └── 002_seed_vendor_platforms.sql
```

## Configuration

### Environment Variables

Create a `.env` file in the `backend/` directory:

```env
# Database connection
DATABASE_URL=postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb

# CORS allowed origins (comma-separated)
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
```

### Database Setup

The application uses PostgreSQL with two schemas:

- **`public` schema**: BetterAuth authentication tables (hands off!)
- **`expert_network` schema**: Application data (campaigns, experts, etc.)

Run migrations to set up the database:

```bash
cd migrations
python run_migrations.py
```

This will:
1. Create the `expert_network` schema
2. Create all application tables
3. Seed 18 expert network vendor platforms

## API Documentation

### Interactive Documentation

FastAPI provides built-in interactive documentation:

- **Swagger UI**: http://localhost:8000/docs
  - Try out endpoints directly
  - View request/response schemas
  - Test authentication

- **ReDoc**: http://localhost:8000/redoc
  - Clean, readable documentation
  - Better for sharing with team

### Full Documentation

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for:
- Complete endpoint reference
- Authentication guide
- Request/response examples
- Error handling
- Example workflows

## Authentication

The API uses BetterAuth for authentication. Most endpoints require a valid session token.

### How It Works

1. User authenticates through the frontend (Next.js with BetterAuth)
2. BetterAuth creates a session in the `public.session` table
3. Frontend includes session token in `Authorization` header
4. Backend validates token against database

### Protected Endpoints

Include the session token in requests:

```bash
curl -H "Authorization: Bearer <your-token>" \
     http://localhost:8000/api/campaigns
```

### Public Endpoints

These endpoints don't require authentication:
- `GET /` - API root
- `GET /health` - Health check
- `GET /api/vendors` - List vendor platforms
- `GET /api/vendors/{id}` - Get vendor details

## Key Features

### Multi-Tenant Architecture
All data is automatically scoped to the authenticated user. Users can only access their own campaigns, experts, and interviews.

### Async Operations
Uses `asyncpg` for high-performance async database operations with connection pooling.

### Type Safety
Pydantic models provide request/response validation and automatic OpenAPI schema generation.

### Comprehensive Error Handling
- 400: Bad Request (invalid data)
- 401: Unauthorized (missing/invalid token)
- 404: Not Found
- 409: Conflict (duplicate resource)
- 500: Internal Server Error

## API Overview

### Core Resources

| Resource | Endpoint | Description |
|----------|----------|-------------|
| **Vendors** | `/api/vendors` | Expert network platforms (GLG, AlphaSights, etc.) |
| **Projects** | `/api/projects` | Top-level project groupings |
| **Campaigns** | `/api/campaigns` | Expert research campaigns |
| **Experts** | `/api/experts` | Expert proposals from vendors |
| **Interviews** | `/api/interviews` | Scheduled expert calls |

### Typical Workflow

```
1. Create Project
   POST /api/projects

2. Create Campaign
   POST /api/campaigns

3. Enroll Vendors
   POST /api/campaigns/{id}/vendors

4. Add Experts (via LLM mock backend)
   POST /api/experts

5. Review & Approve Experts
   PATCH /api/experts/{id}

6. Schedule Interviews
   POST /api/interviews

7. Complete Interviews & Add Notes
   PATCH /api/interviews/{id}
```

## Development

### Running Tests

```bash
# Install test dependencies
pip install pytest pytest-asyncio httpx

# Run tests
pytest
```

### Code Style

```bash
# Format code
black .

# Check types
mypy .

# Lint
ruff check .
```

### Database Utilities

The `db.py` module provides helpful utilities:

```python
from db import (
    get_db,                    # Get connection from pool
    execute_query,             # Execute query with params
    insert_and_return,         # INSERT ... RETURNING
    update_and_return,         # UPDATE ... RETURNING
    get_campaign,              # Get campaign by ID
    get_user_campaigns,        # Get user's campaigns
    get_campaign_experts,      # Get experts for campaign
    get_vendor_platforms,      # Get all vendors
    enroll_vendor,             # Enroll vendor in campaign
)
```

### Creating a New Endpoint

1. **Define Pydantic model** in `models/`:
   ```python
   # models/my_model.py
   from pydantic import BaseModel

   class MyModelCreate(BaseModel):
       name: str
       description: str
   ```

2. **Create API router** in `api/`:
   ```python
   # api/my_resource.py
   from fastapi import APIRouter

   router = APIRouter(prefix="/api/my-resource", tags=["My Resource"])

   @router.post("")
   async def create(data: MyModelCreate):
       # Implementation
       pass
   ```

3. **Register router** in `main.py`:
   ```python
   from api.my_resource import router as my_resource_router

   app.include_router(my_resource_router)
   ```

## Database Schema

### Key Tables

- **projects**: Top-level project groupings
- **campaigns**: Expert research campaigns
- **vendor_platforms**: Expert network vendors (GLG, etc.)
- **campaign_vendor_enrollments**: Vendors enrolled in campaigns
- **experts**: Expert proposals from vendors
- **interviews**: Scheduled expert calls
- **screening_questions**: Questions for expert vetting
- **expert_screening_responses**: Expert answers to screening questions
- **team_members**: Team members assigned to campaigns

### Relationships

```
projects (1) ──── (N) campaigns
                      │
                      ├── (N) experts
                      │        │
                      │        └── (N) interviews
                      │
                      └── (N) campaign_vendor_enrollments
                               │
                               └── (1) vendor_platforms
```

All tables include:
- `id` (UUID primary key)
- `created_at` (timestamp)
- `updated_at` (timestamp, auto-updated via trigger)

## Production Deployment

### Using uvicorn

```bash
# Single worker
uvicorn main:app --host 0.0.0.0 --port 8000

# Multiple workers
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Using Gunicorn

```bash
gunicorn main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000
```

### Docker

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Environment Variables for Production

```env
DATABASE_URL=postgresql+asyncpg://user:pass@prod-db:5432/dbname
ALLOWED_ORIGINS=https://yourdomain.com
```

## Troubleshooting

### Database Connection Issues

```bash
# Test connection
psql postgresql://raguser:ragpass@localhost:5432/ragdb

# Check if PostgreSQL is running
# Linux: systemctl status postgresql
# Mac: brew services list
# Windows: services.msc
```

### Migration Issues

```bash
# Check migration status
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT * FROM public.schema_migrations;
"

# Reset migrations (CAREFUL!)
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  DROP SCHEMA IF EXISTS expert_network CASCADE;
  DROP TABLE IF EXISTS public.schema_migrations;
"
python migrations/run_migrations.py
```

### Import Errors

```bash
# Ensure you're in the backend directory
cd backend

# Install dependencies
pip install -r requirements.txt

# Check Python version (requires 3.10+)
python --version
```

## Performance Tips

1. **Connection Pooling**: Already configured in `db.py`
2. **Async Queries**: Use `await` for all database operations
3. **Indexes**: Already created on foreign keys and common query fields
4. **Pagination**: Use `PaginationParams` model for large result sets
5. **Caching**: Consider Redis for vendor platform data

## Security Considerations

- ✅ All queries use parameterized statements (SQL injection safe)
- ✅ Authentication required for all sensitive endpoints
- ✅ User-scoped queries (multi-tenant isolation)
- ✅ CORS configured for known origins
- ⚠️ Use HTTPS in production
- ⚠️ Store DATABASE_URL in secure secrets manager
- ⚠️ Rate limiting not yet implemented

## Next Steps

1. **Frontend Integration**
   - Update frontend to call API endpoints instead of localStorage
   - Implement API client with TypeScript types

2. **LLM Mock Backend**
   - Create Python script to simulate vendor expert proposals
   - Use OpenAI API for realistic expert generation

3. **Testing**
   - Write unit tests for API endpoints
   - Create integration tests for workflows

4. **Monitoring**
   - Add application logging
   - Set up health check monitoring
   - Track API response times

## Support

- **API Documentation**: http://localhost:8000/docs
- **Full Docs**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- **Database Setup**: [MIGRATION_SETUP.md](MIGRATION_SETUP.md)
- **Python Integration**: [../PYTHON_BACKEND_INTEGRATION.md](../PYTHON_BACKEND_INTEGRATION.md)
