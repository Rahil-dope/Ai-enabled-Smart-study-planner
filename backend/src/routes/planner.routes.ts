import { Router } from 'express';
import { generatePlan } from '../controllers/planner.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.post('/generate-plan', authenticateToken, generatePlan);

export default router;
