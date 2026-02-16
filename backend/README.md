# Backend API Documentation

## Overview
REST API for Smart Study Planner built with Node.js, Express, and PostgreSQL.

## Base URL
```
http://localhost:3000/api/v1
```

## Authentication
All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

## API Reference

### Authentication Endpoints

#### Register User
```http
POST /auth/register
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securepassword123"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
}
```

#### Login User
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securepassword123"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": { "id": "uuid", "name": "John Doe", "email": "john@example.com" },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
}
```

#### Get Current User
```http
GET /auth/me
```
🔒 **Protected Route**

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Goals Endpoints

#### Create Goal
```http
POST /goals
```
🔒 **Protected Route**

**Request Body:**
```json
{
  "title": "Learn Linear Algebra",
  "description": "Complete MIT 18.06 course",
  "deadline": "2024-06-30"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "title": "Learn Linear Algebra",
    "description": "Complete MIT 18.06 course",
    "deadline": "2024-06-30T00:00:00.000Z",
    "status": "active",
    "created_at": "2024-02-16T18:00:00.000Z"
  }
}
```

#### Get User Goals
```http
GET /goals
```
🔒 **Protected Route**

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "Learn Linear Algebra",
      "description": "Complete MIT 18.06 course",
      "deadline": "2024-06-30T00:00:00.000Z",
      "status": "active",
      "created_at": "2024-02-16T18:00:00.000Z"
    }
  ]
}
```

### AI Planning Endpoints

#### Generate Study Plan
```http
POST /ai/generate-plan
```
🔒 **Protected Route**

**Request Body:**
```json
{
  "goalId": "uuid",
  "hoursPerDay": 2,
  "existingKnowledge": "Beginner"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "planId": "uuid",
    "message": "Study plan generated successfully",
    "totalDays": 30
  }
}
```

### Tasks Endpoints

#### Get Tasks
```http
GET /tasks?goalId={goalId}
```
or
```http
GET /tasks?planId={planId}
```
🔒 **Protected Route**

**Query Parameters:**
- `goalId` (optional): Get tasks by goal ID
- `planId` (optional): Get tasks by plan ID

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "day_number": 1,
      "est_minutes": 120,
      "is_completed": false,
      "topics": [
        { "id": "uuid", "name": "Vector Spaces", "is_completed": false },
        { "id": "uuid", "name": "Linear Independence", "is_completed": false }
      ]
    }
  ]
}
```

#### Update Task Status
```http
PUT /tasks/:id
```
🔒 **Protected Route**

**Request Body:**
```json
{
  "isCompleted": true
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "is_completed": true
  }
}
```

### Analytics Endpoints

#### Get Dashboard Stats
```http
GET /dashboard
```
🔒 **Protected Route**

**Response (200):**
```json
{
  "success": true,
  "data": {
    "tasksCompletedToday": 3,
    "activeGoals": 2,
    "totalStudyMinutes": 450,
    "streakDays": 5
  }
}
```

## Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message"
  }
}
```

**Error Codes:**
- `VALIDATION_ERROR` (400): Invalid request data
- `UNAUTHORIZED` (401): Missing or invalid token
- `NOT_FOUND` (404): Resource not found
- `AI_SERVICE_ERROR` (500): OpenAI API failure
- `INTERNAL_ERROR` (500): Server error

## Development

### Running Migrations
```bash
psql -U postgres -d study_planner -f src/migrations/001_create_users_table.sql
psql -U postgres -d study_planner -f src/migrations/002_create_goals_subjects_tables.sql
psql -U postgres -d study_planner -f src/migrations/003_create_planner_tables.sql
```

### Environment Variables
```env
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/study_planner
NODE_ENV=development
JWT_SECRET=your-secret-key
OPENAI_API_KEY=sk-...
```
