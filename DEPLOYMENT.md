# Deployment Guide

This guide covers deploying the Smart Study Planner to production environments.

## 🎯 Deployment Options

### Backend Deployment

#### Option 1: Railway (Recommended)

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Initialize project**
   ```bash
   cd backend
   railway init
   ```

4. **Add PostgreSQL**
   ```bash
   railway add --plugin postgresql
   ```

5. **Set environment variables**
   ```bash
   railway variables set JWT_SECRET="your-production-secret"
   railway variables set OPENAI_API_KEY="sk-..."
   railway variables set NODE_ENV="production"
   ```

6. **Deploy**
   ```bash
   railway up
   ```

7. **Run migrations**
   ```bash
   railway run bash
   # Inside shell:
   psql $DATABASE_URL -f src/migrations/001_create_users_table.sql
   psql $DATABASE_URL -f src/migrations/002_create_goals_subjects_tables.sql
   psql $DATABASE_URL -f src/migrations/003_create_planner_tables.sql
   ```

#### Option 2: Render

1. **Create account** at [render.com](https://render.com)

2. **Create new Web Service**
   - Connect GitHub repository
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`

3. **Add PostgreSQL Database**
   - Create PostgreSQL instance
   - Copy connection string

4. **Set Environment Variables**
   ```
   DATABASE_URL=<from-render-postgres>
   JWT_SECRET=<generate-secure-secret>
   OPENAI_API_KEY=<your-key>
   NODE_ENV=production
   ```

5. **Run migrations** via Render Shell

#### Option 3: VPS (DigitalOcean/AWS)

1. **Provision server** (Ubuntu 22.04)

2. **Install dependencies**
   ```bash
   sudo apt update
   sudo apt install -y nodejs npm postgresql
   ```

3. **Clone repository**
   ```bash
   git clone <your-repo>
   cd backend
   npm install
   npm run build
   ```

4. **Setup PostgreSQL**
   ```bash
   sudo -u postgres createdb study_planner
   sudo -u postgres psql study_planner < migrations/001_create_users_table.sql
   sudo -u postgres psql study_planner < migrations/002_create_goals_subjects_tables.sql
   sudo -u postgres psql study_planner < migrations/003_create_planner_tables.sql
   ```

5. **Setup PM2**
   ```bash
   npm install -g pm2
   pm2 start dist/index.js --name study-planner-api
   pm2 startup
   pm2 save
   ```

6. **Setup Nginx**
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### Mobile App Deployment

#### Android

1. **Update package name**
   Edit `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       applicationId "com.yourdomain.studyplanner"
       ...
   }
   ```

2. **Generate signing key**
   ```bash
   keytool -genkey -v -keystore ~/study-planner-key.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias study-planner
   ```

3. **Configure signing**
   Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<key-password>
   keyAlias=study-planner
   storeFile=/path/to/study-planner-key.jks
   ```

4. **Update build.gradle**
   ```gradle
   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

5. **Build release APK**
   ```bash
   flutter build apk --release
   ```

6. **Build App Bundle** (for Play Store)
   ```bash
   flutter build appbundle --release
   ```

7. **Upload to Google Play Console**

#### iOS

1. **Configure Xcode project**
   - Open `ios/Runner.xcworkspace`
   - Update Bundle Identifier
   - Configure signing certificates

2. **Update Info.plist** for permissions

3. **Build archive**
   ```bash
   flutter build ios --release
   ```

4. **Archive in Xcode**
   - Product → Archive
   - Upload to App Store Connect

## 🔐 Security Checklist

### Backend
- [ ] Strong JWT_SECRET in production
- [ ] HTTPS/TLS enabled
- [ ] CORS configured for production domain only
- [ ] Rate limiting enabled
- [ ] SQL injection prevention (parameterized queries ✓)
- [ ] Environment variables secured
- [ ] Database backups configured
- [ ] Logging and monitoring enabled

### Mobile
- [ ] API keys not hardcoded
- [ ] Production API URL configured
- [ ] SSL certificate pinning (optional)
- [ ] Sensitive data encrypted in storage
- [ ] App obfuscation enabled
- [ ] Release builds tested

## 📊 Monitoring

### Backend Monitoring

**Using Railway/Render:**
- Built-in metrics and logs
- Set up alerts for errors

**Using PM2:**
```bash
pm2 monit
pm2 logs
```

**Custom logging:**
Consider adding services like:
- Sentry for error tracking
- LogRocket for user sessions
- DataDog for infrastructure

### Mobile Monitoring

- **Crashlytics**: Firebase Crashlytics
- **Analytics**: Firebase Analytics or Mixpanel
- **Performance**: Firebase Performance Monitoring

## 🔄 CI/CD

### GitHub Actions Example

`.github/workflows/backend-deploy.yml`:
```yaml
name: Deploy Backend

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        working-directory: ./backend
        run: npm ci
      
      - name: Run tests
        working-directory: ./backend
        run: npm test
      
      - name: Build
        working-directory: ./backend
        run: npm run build
      
      - name: Deploy to Railway
        run: railway up
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

## 🗄️ Database Management

### Backups

**Automated (Railway/Render):**
- Enable automatic backups in dashboard

**Manual PostgreSQL backup:**
```bash
pg_dump DATABASE_URL > backup.sql
```

**Restore:**
```bash
psql DATABASE_URL < backup.sql
```

### Migrations

Create a migration script in `backend/package.json`:
```json
{
  "scripts": {
    "migrate": "node scripts/migrate.js"
  }
}
```

## 🚨 Rollback Plan

1. **Backend:** Use Railway/Render deployment history to rollback
2. **Database:** Restore from backup if schema changes
3. **Mobile:** Release hotfix update via app stores

## 📝 Post-Deployment

- [ ] Test all API endpoints
- [ ] Verify mobile app connectivity
- [ ] Check analytics/monitoring
- [ ] Update documentation with production URLs
- [ ] Notify users of new release

## 🆘 Troubleshooting

### Backend not starting
- Check environment variables
- Verify database connection
- Check logs: `railway logs` or `pm2 logs`

### Mobile app can't connect
- Verify production API URL
- Check HTTPS certificate
- Test API endpoints manually (Postman)
- Check CORS settings

### Database connection errors
- Verify DATABASE_URL format
- Check firewall rules
- Confirm database is running
- Test connection: `psql $DATABASE_URL`
