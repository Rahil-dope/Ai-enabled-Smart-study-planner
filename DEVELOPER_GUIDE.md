# Developer Guide

Welcome to the Smart Study Planner development team! This guide will help you get started with the project.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Database Management](#database-management)
- [Testing](#testing)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- **Node.js** 18.x or higher
- **PostgreSQL** 14.x or higher
- **Flutter** 3.0.0 or higher
- **Git**
- **VS Code** or **Android Studio** (recommended)

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd PLANER
   ```

2. **Backend Setup**
   ```bash
   cd backend
   npm install
   ```

3. **Create PostgreSQL database**
   ```bash
   createdb study_planner
   ```

4. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

5. **Run migrations**
   ```bash
   psql -d study_planner -f src/migrations/001_create_users_table.sql
   psql -d study_planner -f src/migrations/002_create_goals_subjects_tables.sql
   psql -d study_planner -f src/migrations/003_create_planner_tables.sql
   ```

6. **Start backend**
   ```bash
   npm run dev
   ```

7. **Mobile Setup** (in new terminal)
   ```bash
   cd ../mobile
   flutter create .  # Generate platform files
   flutter pub get
   flutter run
   ```

## 📁 Project Structure

### Backend (`/backend`)

```
backend/
├── src/
│   ├── controllers/      # Request handlers
│   │   ├── auth.controller.ts
│   │   ├── goals.controller.ts
│   │   ├── tasks.controller.ts
│   │   └── analytics.controller.ts
│   ├── middleware/       # Express middleware
│   │   └── auth.middleware.ts
│   ├── routes/          # API route definitions
│   ├── services/        # Business logic
│   │   └── ai.service.ts
│   ├── migrations/      # Database schemas
│   ├── db.ts           # Database connection
│   └── index.ts        # App entry point
├── package.json
└── tsconfig.json
```

### Mobile (`/mobile`)

```
mobile/
├── lib/
│   ├── core/
│   │   ├── constants/    # App constants
│   │   └── theme/        # Theme config
│   ├── data/
│   │   ├── datasources/  # API clients
│   │   ├── models/       # Data models
│   │   └── repositories/ # Data access layer
│   └── presentation/
│       ├── screens/      # UI pages
│       └── viewmodels/   # State management
└── pubspec.yaml
```

## 🔄 Development Workflow

### Backend Development

1. **Create new feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes** following coding standards

3. **Test locally**
   ```bash
   npm run dev
   # Test in Postman/Thunder Client
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

### Mobile Development

1. **Hot reload** is enabled by default
   - Save files to see changes immediately
   - Press `r` in terminal for manual reload
   - Press `R` for hot restart

2. **Add new screens**
   - Create screen in `lib/presentation/screens/`
   - Create corresponding viewmodel if needed
   - Register viewmodel in `main.dart`

3. **Test on multiple devices**
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

## 📝 Coding Standards

### Backend (TypeScript)

**Controller Pattern:**
```typescript
export const createGoal = async (req: AuthRequest, res: Response) => {
  const { title, description, deadline } = req.body;
  const userId = req.user.id;

  // Validation
  if (!title || !deadline) {
    return res.status(400).json({ 
      success: false, 
      error: { code: 'VALIDATION_ERROR', message: 'Missing required fields' } 
    });
  }

  try {
    // Business logic
    const result = await query('INSERT INTO goals ...');
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ 
      success: false, 
      error: { code: 'INTERNAL_ERROR', message: 'Server error' } 
    });
  }
};
```

**Standards:**
- Use `async/await` over callbacks
- Always use parameterized queries (SQL injection prevention)
- Return consistent response format: `{ success: boolean, data/error: any }`
- Use TypeScript types for request/response
- Log errors with `console.error`

### Mobile (Dart/Flutter)

**ViewModel Pattern:**
```dart
class GoalViewModel extends ChangeNotifier {
  final GoalRepository _repository = GoalRepository();
  List<Goal> _goals = [];
  bool _isLoading = false;

  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _goals = await _repository.getGoals();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Standards:**
- Use `const` constructors where possible
- Follow Clean Architecture (data/domain/presentation)
- Use Provider for state management
- Handle loading/error states
- Use meaningful widget names
- Extract reusable widgets

### Naming Conventions

**Backend:**
- Files: `snake_case.ts` (e.g., `auth.controller.ts`)
- Functions: `camelCase` (e.g., `createGoal`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `JWT_SECRET`)

**Mobile:**
- Files: `snake_case.dart` (e.g., `goal_viewmodel.dart`)
- Classes: `PascalCase` (e.g., `GoalViewModel`)
- Variables: `camelCase` (e.g., `goalTitle`)
- Private: `_prefixed` (e.g., `_isLoading`)

## 🗄️ Database Management

### Creating Migrations

1. Create SQL file in `backend/src/migrations/`
2. Name format: `00X_description.sql`
3. Include both table creation and constraints

**Example:**
```sql
-- 004_create_new_table.sql
CREATE TABLE IF NOT EXISTS new_table (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Running Migrations

**Development:**
```bash
psql -d study_planner -f src/migrations/004_create_new_table.sql
```

**Production:**
```bash
# Railway/Render
railway run bash
psql $DATABASE_URL -f src/migrations/004_create_new_table.sql
```

### Database Queries

Always use parameterized queries:
```typescript
// ✅ CORRECT
const result = await query('SELECT * FROM users WHERE id = $1', [userId]);

// ❌ WRONG (SQL injection vulnerability)
const result = await query(`SELECT * FROM users WHERE id = '${userId}'`);
```

## 🧪 Testing

### Backend Testing

**Manual API Testing:**
1. Use Thunder Client or Postman
2. Import collection from `/backend/tests/api-collection.json` (if exists)
3. Test authentication flow first

**Example requests:**
```bash
# Register
POST http://localhost:3000/api/v1/auth/register
Content-Type: application/json

{
  "name": "Test User",
  "email": "test@example.com",
  "password": "password123"
}

# Create Goal (with token)
POST http://localhost:3000/api/v1/goals
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Learn Algebra",
  "description": "Complete course",
  "deadline": "2024-12-31"
}
```

### Mobile Testing

**Widget Tests:**
```dart
testWidgets('Login button appears', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('LOGIN'), findsOneWidget);
});
```

**Run tests:**
```bash
flutter test
flutter test --coverage
```

## 🛠️ Common Tasks

### Adding a New API Endpoint

1. **Create controller function** (`controllers/feature.controller.ts`)
2. **Create route** (`routes/feature.routes.ts`)
3. **Register route** in `index.ts`
4. **Test with Postman**

### Adding a New Screen

1. **Create screen file** (`presentation/screens/new_screen.dart`)
2. **Create viewmodel** (`presentation/viewmodels/new_viewmodel.dart`)
3. **Register provider** in `main.dart`
4. **Add navigation** from existing screen

### Updating Dependencies

**Backend:**
```bash
npm update
npm audit fix
```

**Mobile:**
```bash
flutter pub upgrade
flutter pub outdated
```

## 🐛 Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:3000 | xargs kill -9
```

**Database connection errors:**
- Check PostgreSQL is running: `pg_isready`
- Verify DATABASE_URL in `.env`
- Check firewall settings

### Mobile Issues

**Build failures:**
```bash
flutter clean
flutter pub get
flutter run
```

**Gradle issues (Android):**
```bash
cd android
./gradlew clean
cd ..
flutter run
```

**Pod installation (iOS):**
```bash
cd ios
pod install
cd ..
flutter run
```

## 📚 Resources

- [TypeScript Docs](https://www.typescriptlang.org/docs/)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

## 🤝 Contributing

1. Follow the coding standards above
2. Write meaningful commit messages
3. Test your changes thoroughly
4. Update documentation if needed
5. Create pull request with description

## 📞 Getting Help

- Check this guide first
- Review existing code for examples
- Ask team members
- Check project documentation in `/docs`

---

Happy coding! 🚀
