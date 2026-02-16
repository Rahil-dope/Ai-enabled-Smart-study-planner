import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import { query } from './db';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
import authRoutes from './routes/auth.routes';
import appRoutes from './routes/app.routes';
import plannerRoutes from './routes/planner.routes';
import taskRoutes from './routes/tasks.routes';
import analyticsRoutes from './routes/analytics.routes';

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1', appRoutes);
app.use('/api/v1/ai', plannerRoutes);
app.use('/api/v1', taskRoutes);
app.use('/api/v1', analyticsRoutes);

// Health Check
app.get('/api/v1/health', async (req, res) => {
    try {
        const result = await query('SELECT NOW()');
        res.json({
            status: 'ok',
            message: 'Server is running',
            dbTime: result.rows[0].now
        });
    } catch (error) {
        console.error('Database connection error:', error);
        res.status(500).json({
            status: 'error',
            message: 'Database connection failed'
        });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
