# Expert Networks API Documentation

## Overview

RESTful API for managing expert network campaigns, expert proposals, and interview scheduling for commercial due diligence projects.

- **Base URL**: `http://localhost:8000`
- **API Version**: 1.0.0
- **Authentication**: BetterAuth session tokens
- **Response Format**: JSON

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Authentication](#authentication)
3. [API Endpoints](#api-endpoints)
   - [Health Check](#health-check)
   - [Vendors](#vendors)
   - [Projects](#projects)
   - [Campaigns](#campaigns)
   - [Experts](#experts)
   - [Interviews](#interviews)
4. [Error Handling](#error-handling)
5. [Data Models](#data-models)

---

## Getting Started

### Installation

```bash
# Navigate to backend directory
cd backend

# Install dependencies
pip install -r requirements.txt

# Run migrations
cd migrations
python run_migrations.py
cd ..

# Start server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Environment Variables

Create a `.env` file in the `backend/` directory:

```env
DATABASE_URL=postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
```

### Interactive Documentation

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI Schema**: http://localhost:8000/openapi.json

---

## Authentication

All endpoints (except `/api/vendors`) require authentication via BetterAuth.

### Request Headers

```http
Authorization: Bearer <your-session-token>
```

### Getting a Session Token

Users authenticate through the frontend BetterAuth flow. The session token is stored in the browser and should be included in all API requests.

### Example Request

```bash
curl -H "Authorization: Bearer abc123def456" \
     http://localhost:8000/api/campaigns
```

---

## API Endpoints

### Health Check

#### `GET /`

Root endpoint providing API information.

**Response:**
```json
{
  "name": "Expert Networks API",
  "version": "1.0.0",
  "status": "online",
  "docs": "/docs",
  "endpoints": {
    "vendors": "/api/vendors",
    "projects": "/api/projects",
    "campaigns": "/api/campaigns",
    "experts": "/api/experts",
    "interviews": "/api/interviews"
  }
}
```

#### `GET /health`

Health check for monitoring.

**Response:**
```json
{
  "status": "healthy"
}
```

---

### Vendors

Expert network vendor platforms (GLG, AlphaSights, etc.).

#### `GET /api/vendors`

List all active vendor platforms.

**Authentication**: Not required

**Response:**
```json
[
  {
    "id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
    "name": "GLG",
    "logo_url": "/images/vendor-logos/GLG.png",
    "location": "New York, USA",
    "overall_score": 4.8,
    "avg_cost_per_call_min": 800,
    "avg_cost_per_call_max": 1500,
    "description": "One of the world's largest expert networks...",
    "tags": ["Global Coverage", "Life Sciences"],
    "is_active": true,
    "created_at": "2025-01-15T10:00:00Z",
    "updated_at": "2025-01-15T10:00:00Z"
  }
]
```

#### `GET /api/vendors/{vendor_id}`

Get details for a specific vendor platform.

**Authentication**: Not required

**Response:** Single vendor object (same structure as above)

---

### Projects

Projects group related campaigns together.

#### `GET /api/projects`

List all projects for the authenticated user.

**Authentication**: Required

**Response:**
```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "user_id": "user_123",
    "project_name": "TechCo Acquisition DD",
    "project_code": "DEAL-2025-001",
    "client_name": "PE Firm XYZ",
    "start_date": "2025-01-15",
    "end_date": "2025-03-15",
    "description": "Commercial due diligence...",
    "display_order": 1,
    "campaign_count": 3,
    "created_at": "2025-01-10T10:00:00Z",
    "updated_at": "2025-01-10T10:00:00Z"
  }
]
```

#### `GET /api/projects/{project_id}`

Get details for a specific project.

**Authentication**: Required

**Response:** Single project object (same structure as above)

#### `POST /api/projects`

Create a new project.

**Authentication**: Required

**Request Body:**
```json
{
  "project_name": "TechCo Acquisition DD",
  "project_code": "DEAL-2025-001",
  "client_name": "PE Firm XYZ",
  "start_date": "2025-01-15",
  "end_date": "2025-03-15",
  "description": "Commercial due diligence for healthcare tech acquisition"
}
```

**Response:** Created project object (201 status)

#### `PATCH /api/projects/{project_id}`

Update a project (all fields optional).

**Authentication**: Required

**Request Body:**
```json
{
  "project_name": "Updated Name",
  "end_date": "2025-04-15"
}
```

**Response:** Updated project object

#### `DELETE /api/projects/{project_id}`

Delete a project.

**Authentication**: Required

**Response:**
```json
{
  "success": true,
  "message": "Project deleted successfully"
}
```

---

### Campaigns

Campaigns represent specific expert research projects.

#### `GET /api/campaigns`

List all campaigns for the authenticated user.

**Authentication**: Required

**Response:**
```json
{
  "campaigns": [
    {
      "id": "campaign-uuid",
      "user_id": "user_123",
      "project_id": "project-uuid",
      "project_name": "TechCo Acquisition DD",
      "campaign_name": "Healthcare AI Market Assessment",
      "industry_vertical": "Healthcare Technology",
      "start_date": "2025-02-01",
      "target_completion_date": "2025-03-15",
      "target_regions": ["North America", "Europe"],
      "min_calls": 15,
      "max_calls": 20,
      "expert_count": 24,
      "interview_count": 8,
      "vendor_enrollment_count": 3,
      "created_at": "2025-01-15T10:00:00Z",
      "updated_at": "2025-02-05T14:30:00Z"
    }
  ],
  "total": 1
}
```

#### `GET /api/campaigns/{campaign_id}`

Get details for a specific campaign.

**Authentication**: Required

**Response:** Single campaign object (same structure as above)

#### `POST /api/campaigns`

Create a new campaign.

**Authentication**: Required

**Request Body:**
```json
{
  "project_id": "project-uuid",
  "campaign_name": "Healthcare AI Market Assessment",
  "industry_vertical": "Healthcare Technology",
  "brief_description": "Understanding AI adoption in clinical workflows",
  "start_date": "2025-02-01",
  "target_completion_date": "2025-03-15",
  "target_regions": ["North America", "Europe"],
  "min_calls": 15,
  "max_calls": 20
}
```

**Response:** Created campaign object (201 status)

#### `PATCH /api/campaigns/{campaign_id}`

Update a campaign.

**Authentication**: Required

**Request Body:** Any campaign fields to update

**Response:** Updated campaign object

#### `DELETE /api/campaigns/{campaign_id}`

Delete a campaign (cascades to experts, interviews, etc.).

**Authentication**: Required

**Response:**
```json
{
  "success": true,
  "message": "Campaign deleted successfully"
}
```

#### `GET /api/campaigns/{campaign_id}/vendors`

List vendors enrolled in a campaign.

**Authentication**: Required

**Response:**
```json
[
  {
    "id": "enrollment-uuid",
    "campaign_id": "campaign-uuid",
    "vendor_platform_id": "vendor-uuid",
    "vendor_name": "GLG",
    "vendor_logo_url": "/images/vendor-logos/GLG.png",
    "status": "active",
    "experts_proposed_count": 12,
    "experts_reviewed_count": 8,
    "interviews_scheduled_count": 3,
    "created_at": "2025-02-01T10:00:00Z",
    "updated_at": "2025-02-05T14:30:00Z"
  }
]
```

#### `POST /api/campaigns/{campaign_id}/vendors`

Enroll a vendor in a campaign.

**Authentication**: Required

**Request Body:**
```json
{
  "vendor_platform_id": "vendor-uuid"
}
```

**Response:** Created enrollment object (201 status)

#### `DELETE /api/campaigns/{campaign_id}/vendors/{vendor_id}`

Remove a vendor from a campaign.

**Authentication**: Required

**Response:**
```json
{
  "success": true,
  "message": "Vendor removed from campaign successfully"
}
```

---

### Experts

Experts proposed by vendors for interview.

#### `GET /api/experts?campaign_id={campaign_id}&status={status}&vendor_id={vendor_id}`

List experts for a campaign.

**Authentication**: Required

**Query Parameters:**
- `campaign_id` (required): Campaign UUID
- `status` (optional): Filter by status (proposed, reviewed, approved, rejected, scheduled)
- `vendor_id` (optional): Filter by vendor platform UUID

**Response:**
```json
{
  "experts": [
    {
      "id": "expert-uuid",
      "campaign_id": "campaign-uuid",
      "vendor_platform_id": "vendor-uuid",
      "vendor_name": "GLG",
      "expert_name": "Dr. Sarah Johnson",
      "current_company": "Memorial Sloan Kettering",
      "current_title": "Director of Clinical AI",
      "location": "New York, NY",
      "years_experience": 15,
      "expertise_areas": ["Clinical AI", "Healthcare IT"],
      "bio": "15+ years experience...",
      "hourly_rate": 800,
      "status": "approved",
      "relevance_score": 92.5,
      "interview_count": 1,
      "created_at": "2025-02-01T10:00:00Z"
    }
  ],
  "total": 1
}
```

#### `GET /api/experts/{expert_id}`

Get details for a specific expert.

**Authentication**: Required

**Response:** Single expert object with screening responses

#### `POST /api/experts`

Create a new expert.

**Authentication**: Required

**Request Body:**
```json
{
  "campaign_id": "campaign-uuid",
  "vendor_platform_id": "vendor-uuid",
  "expert_name": "Dr. Sarah Johnson",
  "current_company": "Memorial Sloan Kettering",
  "current_title": "Director of Clinical AI",
  "location": "New York, NY",
  "years_experience": 15,
  "expertise_areas": ["Clinical AI", "Healthcare IT"],
  "bio": "15+ years experience...",
  "hourly_rate": 800,
  "status": "proposed"
}
```

**Response:** Created expert object (201 status)

#### `PATCH /api/experts/{expert_id}`

Update an expert.

**Authentication**: Required

**Request Body:** Any expert fields to update

**Response:** Updated expert object

#### `DELETE /api/experts/{expert_id}`

Delete an expert.

**Authentication**: Required

**Response:**
```json
{
  "success": true,
  "message": "Expert deleted successfully"
}
```

#### `GET /api/experts/{expert_id}/screening`

Get screening responses for an expert.

**Authentication**: Required

**Response:**
```json
[
  {
    "id": "response-uuid",
    "expert_id": "expert-uuid",
    "question_id": "question-uuid",
    "question_text": "What experience do you have with AI in clinical settings?",
    "response_text": "I have implemented AI diagnostic tools...",
    "rating": 5,
    "created_at": "2025-02-01T10:00:00Z"
  }
]
```

#### `POST /api/experts/{expert_id}/screening`

Add a screening response.

**Authentication**: Required

**Request Body:**
```json
{
  "expert_id": "expert-uuid",
  "question_id": "question-uuid",
  "response_text": "I have implemented AI diagnostic tools...",
  "rating": 5
}
```

**Response:** Created screening response (201 status)

---

### Interviews

Scheduled calls with experts.

#### `GET /api/interviews?campaign_id={campaign_id}&status={status}`

List interviews for a campaign.

**Authentication**: Required

**Query Parameters:**
- `campaign_id` (required): Campaign UUID
- `status` (optional): Filter by status (scheduled, completed, cancelled, no_show)

**Response:**
```json
{
  "interviews": [
    {
      "id": "interview-uuid",
      "campaign_id": "campaign-uuid",
      "expert_id": "expert-uuid",
      "expert_name": "Dr. Sarah Johnson",
      "expert_company": "Memorial Sloan Kettering",
      "vendor_name": "GLG",
      "scheduled_date": "2025-02-15T14:00:00Z",
      "duration_minutes": 60,
      "status": "completed",
      "interview_notes": "Discussed AI implementation challenges...",
      "key_insights": "1. Data quality is key\n2. Physician buy-in critical",
      "interviewer_name": "John Smith",
      "created_at": "2025-02-10T10:00:00Z"
    }
  ],
  "total": 1
}
```

#### `GET /api/interviews/{interview_id}`

Get details for a specific interview.

**Authentication**: Required

**Response:** Single interview object (same structure as above)

#### `POST /api/interviews`

Schedule a new interview.

**Authentication**: Required

**Request Body:**
```json
{
  "campaign_id": "campaign-uuid",
  "expert_id": "expert-uuid",
  "scheduled_date": "2025-02-15T14:00:00Z",
  "duration_minutes": 60,
  "status": "scheduled",
  "interviewer_name": "John Smith"
}
```

**Response:** Created interview object (201 status)

#### `PATCH /api/interviews/{interview_id}`

Update an interview.

**Authentication**: Required

**Request Body:**
```json
{
  "status": "completed",
  "interview_notes": "Discussed AI implementation...",
  "key_insights": "1. Data quality is key..."
}
```

**Response:** Updated interview object

#### `DELETE /api/interviews/{interview_id}`

Delete an interview.

**Authentication**: Required

**Response:**
```json
{
  "success": true,
  "message": "Interview deleted successfully"
}
```

---

## Error Handling

### Standard Error Response

```json
{
  "success": false,
  "error": "Error Type",
  "detail": "Detailed error message"
}
```

### HTTP Status Codes

- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Missing or invalid authentication
- **404 Not Found**: Resource not found
- **409 Conflict**: Resource already exists
- **500 Internal Server Error**: Server error

### Common Errors

#### 401 Unauthorized
```json
{
  "detail": "Missing authorization header"
}
```

#### 404 Not Found
```json
{
  "success": false,
  "error": "Not Found",
  "detail": "Campaign not found"
}
```

#### 400 Bad Request
```json
{
  "success": false,
  "error": "Bad Request",
  "detail": "No fields to update"
}
```

---

## Data Models

### Project
- `id`: UUID
- `user_id`: string
- `project_name`: string (required)
- `project_code`: string (optional)
- `client_name`: string (optional)
- `start_date`: date (optional)
- `end_date`: date (optional)
- `description`: string (optional)
- `display_order`: integer
- `campaign_count`: integer (computed)
- `created_at`: datetime
- `updated_at`: datetime

### Campaign
- `id`: UUID
- `user_id`: string
- `project_id`: UUID (optional)
- `campaign_name`: string (required)
- `industry_vertical`: string (required)
- `brief_description`: string (optional)
- `start_date`: date (required)
- `target_completion_date`: date (required)
- `target_regions`: array of strings
- `min_calls`: integer (optional)
- `max_calls`: integer (optional)
- `display_order`: integer
- `expert_count`: integer (computed)
- `interview_count`: integer (computed)
- `vendor_enrollment_count`: integer (computed)
- `created_at`: datetime
- `updated_at`: datetime

### Expert
- `id`: UUID
- `campaign_id`: UUID
- `vendor_platform_id`: UUID
- `expert_name`: string (required)
- `current_company`: string (optional)
- `current_title`: string (optional)
- `location`: string (optional)
- `linkedin_url`: string (optional)
- `email`: email (optional)
- `phone`: string (optional)
- `years_experience`: integer (optional)
- `expertise_areas`: array of strings
- `bio`: string (optional)
- `hourly_rate`: integer (optional)
- `status`: string (proposed, reviewed, approved, rejected, scheduled)
- `internal_notes`: string (optional)
- `relevance_score`: float (0-100, optional)
- `created_at`: datetime
- `updated_at`: datetime

### Interview
- `id`: UUID
- `campaign_id`: UUID
- `expert_id`: UUID
- `user_id`: string
- `scheduled_date`: datetime (required)
- `duration_minutes`: integer (15-240, default: 60)
- `status`: string (scheduled, completed, cancelled, no_show)
- `interview_notes`: string (optional)
- `key_insights`: string (optional)
- `recording_url`: URL (optional)
- `transcript_text`: string (optional)
- `interviewer_name`: string (optional)
- `created_at`: datetime
- `updated_at`: datetime

---

## Example Usage

### Complete Workflow Example

```python
import requests

BASE_URL = "http://localhost:8000"
TOKEN = "your-session-token"
headers = {"Authorization": f"Bearer {TOKEN}"}

# 1. Create a project
project = requests.post(
    f"{BASE_URL}/api/projects",
    json={
        "project_name": "TechCo Acquisition",
        "project_code": "DEAL-2025-001",
        "start_date": "2025-02-01",
        "end_date": "2025-04-01"
    },
    headers=headers
).json()

# 2. Create a campaign
campaign = requests.post(
    f"{BASE_URL}/api/campaigns",
    json={
        "project_id": project["id"],
        "campaign_name": "Market Assessment",
        "industry_vertical": "Healthcare AI",
        "start_date": "2025-02-01",
        "target_completion_date": "2025-03-15",
        "target_regions": ["North America"],
        "min_calls": 15,
        "max_calls": 20
    },
    headers=headers
).json()

# 3. Get vendor platforms
vendors = requests.get(f"{BASE_URL}/api/vendors").json()
glg = next(v for v in vendors if v["name"] == "GLG")

# 4. Enroll vendor in campaign
enrollment = requests.post(
    f"{BASE_URL}/api/campaigns/{campaign['id']}/vendors",
    json={"vendor_platform_id": glg["id"]},
    headers=headers
).json()

# 5. Add an expert (typically done by LLM mock backend)
expert = requests.post(
    f"{BASE_URL}/api/experts",
    json={
        "campaign_id": campaign["id"],
        "vendor_platform_id": glg["id"],
        "expert_name": "Dr. Jane Smith",
        "current_company": "Hospital XYZ",
        "current_title": "Chief Medical Officer",
        "years_experience": 20,
        "expertise_areas": ["Healthcare AI", "Clinical Workflows"],
        "status": "proposed"
    },
    headers=headers
).json()

# 6. Approve expert
requests.patch(
    f"{BASE_URL}/api/experts/{expert['id']}",
    json={"status": "approved"},
    headers=headers
)

# 7. Schedule interview
interview = requests.post(
    f"{BASE_URL}/api/interviews",
    json={
        "campaign_id": campaign["id"],
        "expert_id": expert["id"],
        "scheduled_date": "2025-02-20T14:00:00Z",
        "duration_minutes": 60,
        "interviewer_name": "John Doe"
    },
    headers=headers
).json()

# 8. Complete interview and add notes
requests.patch(
    f"{BASE_URL}/api/interviews/{interview['id']}",
    json={
        "status": "completed",
        "interview_notes": "Great insights on AI adoption challenges...",
        "key_insights": "1. Data quality is critical\n2. Physician training needed"
    },
    headers=headers
)
```

---

## Need Help?

- **Interactive Docs**: http://localhost:8000/docs
- **API Schema**: http://localhost:8000/openapi.json
- **Issues**: Check the GitHub repository
