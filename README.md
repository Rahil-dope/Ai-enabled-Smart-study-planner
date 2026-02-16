# Smart Study Planner ⚡🧠

> An AI-driven intelligent study execution system that transforms academic goals into structured, adaptive, and achievable daily plans.

Smart Study Planner is a mobile-first, production-grade application built to eliminate decision fatigue and bring clarity, structure, and consistency to student learning workflows. It combines intelligent scheduling, real-time analytics, and AI-powered planning to help students execute their goals efficiently.

---

## Vision 🚀

Traditional planning tools require manual effort and provide no intelligence. Smart Study Planner acts as a personal AI study strategist that:

- Converts goals into executable daily tasks
- Optimizes study schedules automatically
- Tracks progress with precision
- Provides clarity, structure, and momentum

This system bridges the gap between **intent and execution**.

---

## Core Capabilities ✨

### AI-Powered Study Planning
- Generates personalized study plans using OpenAI
- Automatically distributes topics across available time
- Adapts planning based on deadlines and workload

### Goal-Centric Workflow
- Create multiple academic or skill goals
- Define deadlines, topics, and study hours
- Structured execution model

### Intelligent Task Management
- Daily task breakdown with topic-level detail
- Completion tracking with optimistic UI updates
- Progress-aware planning

### Real-Time Progress Analytics
- Active goals, tasks completed, study minutes
- Streak tracking for consistency
- Visual progress indicators on plan detail screen

### Secure Authentication System
- JWT-based authentication (24h access tokens)
- Password hashing using bcrypt
- Input validation with email format & password length checks
- Protected API endpoints

### Mobile-First Experience
- Built using Flutter with Material 3 design
- Cross-platform (Android & iOS)
- Smooth, responsive UI with micro-animations

---

## System Architecture 🏗️

```
Mobile App (Flutter + Provider)
        │
        ▼
REST API (Node.js + Express + TypeScript)
        │
        ▼
Business Logic Layer (AI Planner, Task Engine)
        │
        ▼
Database Layer (PostgreSQL)
        │
        ▼
AI Integration (OpenAI API)
```

**Architecture Principles:**

- Clean Architecture (Mobile)
- MVVM Pattern (Presentation Layer)
- Modular Backend Design (Controllers → Routes → Services)
- Scalable Infrastructure
- Separation of Concerns

---

## Technology Stack ⚙️

| Layer | Technology |
|-------|-----------|
| **Mobile App** | Flutter, Dart, Provider, Dio |
| **Backend API** | Node.js, Express.js, TypeScript |
| **Database** | PostgreSQL |
| **AI Integration** | OpenAI GPT API |
| **Authentication** | JWT, bcryptjs |
| **Dev Tools** | Nodemon, ts-node |

---

## System Requirements 📋

**Required:**

| Tool | Version |
|------|---------|
| Node.js | >= 18.x |
| PostgreSQL | >= 14.x |
| Flutter | >= 3.x |
| OpenAI API Key | — |

**Recommended:**
- VS Code with Flutter & TypeScript extensions
- Android Studio (for emulator)
- Postman (for API testing)

---

## Installation & Setup 🔧

### Backend Setup

**1. Navigate to backend**

```bash
cd backend
```

**2. Install dependencies**

```bash
npm install
```

**3. Configure environment**

Create a `.env` file in the `backend/` directory:

```env
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/study_planner
NODE_ENV=development
JWT_SECRET=your-secure-secret
OPENAI_API_KEY=your-openai-api-key
```

**4. Create database & run migrations**

```bash
# Create the database first
psql -U postgres -c "CREATE DATABASE study_planner;"

# Run migrations in order
psql -U postgres -d study_planner -f src/migrations/001_create_users_table.sql
psql -U postgres -d study_planner -f src/migrations/002_create_goals_subjects_tables.sql
psql -U postgres -d study_planner -f src/migrations/003_create_planner_tables.sql
```

**5. Start backend server**

```bash
npm run dev
```

Server runs at `http://localhost:3000`

---

### Mobile App Setup

**1. Navigate to mobile directory**

```bash
cd mobile
```

**2. Initialize Flutter project (first time only)**

```bash
flutter create .
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure API endpoint**

Edit `lib/core/constants/app_constants.dart`:

```dart
// Android Emulator → use 10.0.2.2
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

// iOS Simulator → use localhost
// static const String baseUrl = 'http://localhost:3000/api/v1';

// Physical Device → use your machine's IP
// static const String baseUrl = 'http://192.168.x.x:3000/api/v1';
```

**5. Run the application**

```bash
flutter run
```

---

## Project Structure 📁

```
Ai-enabled-Smart-study-planner/
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   │   ├── auth.controller.ts
│   │   │   ├── goals.controller.ts
│   │   │   ├── subjects.controller.ts
│   │   │   ├── planner.controller.ts
│   │   │   ├── tasks.controller.ts
│   │   │   └── analytics.controller.ts
│   │   ├── middleware/
│   │   │   └── auth.middleware.ts
│   │   ├── routes/
│   │   │   ├── auth.routes.ts
│   │   │   ├── app.routes.ts
│   │   │   ├── planner.routes.ts
│   │   │   ├── tasks.routes.ts
│   │   │   └── analytics.routes.ts
│   │   ├── services/
│   │   │   └── ai.service.ts
│   │   ├── migrations/
│   │   │   ├── 001_create_users_table.sql
│   │   │   ├── 002_create_goals_subjects_tables.sql
│   │   │   └── 003_create_planner_tables.sql
│   │   ├── db.ts
│   │   └── index.ts
│   ├── .env
│   ├── package.json
│   └── tsconfig.json
│
├── mobile/
│   ├── lib/
│   │   ├── core/
│   │   │   ├── theme/app_theme.dart
│   │   │   └── constants/app_constants.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── viewmodels/
│   │   └── main.dart
│   └── pubspec.yaml
│
├── README.md
├── DEPLOYMENT.md
└── DEVELOPER_GUIDE.md
```

---

## API Endpoints 🌐

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/auth/register` | Register new user |
| `POST` | `/api/v1/auth/login` | Login user |
| `GET` | `/api/v1/auth/me` | Get current user |

### Goals & Subjects
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/goals` | Create a goal |
| `GET` | `/api/v1/goals` | Get all goals |
| `POST` | `/api/v1/subjects` | Create a subject |
| `GET` | `/api/v1/subjects` | Get all subjects |

### AI Planning
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/ai/generate-plan` | Generate AI study plan |

### Tasks & Analytics
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/tasks` | Get tasks (by planId or goalId) |
| `PUT` | `/api/v1/tasks/:id` | Update task completion |
| `GET` | `/api/v1/dashboard` | Get dashboard statistics |

---

## Security Model 🔐

| Mechanism | Implementation |
|-----------|---------------|
| Password Hashing | bcryptjs (10 salt rounds) |
| Authentication | JWT with 24h access + 7d refresh tokens |
| Input Validation | Email regex, password length, required fields |
| Route Protection | Bearer token middleware on all protected routes |
| Headers | Helmet.js security headers |
| CORS | Configured via cors middleware |

---

## Build for Production 📦

### Backend
```bash
npm run build    # Compile TypeScript → dist/
npm start        # Run compiled JavaScript
```

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

---

## System Capabilities Overview 📊

| Feature | Status |
|---------|--------|
| User Authentication | ✅ Complete |
| Goal Management | ✅ Complete |
| Subject Management | ✅ Complete |
| AI Study Plan Generation | ✅ Complete |
| Task Engine | ✅ Complete |
| Analytics Dashboard | ✅ Complete |
| Mobile App (Flutter) | ✅ Complete |
| Backend API (Express) | ✅ Complete |
| Database Schema | ✅ Complete |

---

## Future Enhancements 🔮

- 📱 Push notifications for daily study reminders
- 🔄 Adaptive AI scheduling based on missed days
- 📊 Habit analytics and performance trends
- 🌐 Multi-device synchronization
- 📶 Offline mode with local caching
- 🖥️ Web dashboard companion
- 🤖 ML-based performance optimization

---

## Developer Information 👨‍💻

| | |
|---|---|
| **Developer** | Rahil Huss |
| **Role** | Full Stack Developer |
| **Project Type** | Production-Grade Academic + Portfolio System |

---

## Impact Statement 💡

Smart Study Planner transforms chaotic study routines into structured, intelligent, and optimized execution workflows — empowering students to achieve academic and career goals with clarity and precision.

---

## License 📄

Educational and portfolio use.

---

*This project demonstrates production-level engineering skills including mobile development, backend architecture, database design, AI integration, authentication systems, and full-stack engineering.*
