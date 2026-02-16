import { Router } from 'express';
import { createGoal, getGoals } from '../controllers/goals.controller';
import { createSubject, getSubjects } from '../controllers/subjects.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

// Protect all routes
router.use(authenticateToken);

// Goals
router.post('/goals', createGoal);
router.get('/goals', getGoals);

// Subjects
router.post('/subjects', createSubject);
router.get('/subjects', getSubjects);

export default router;
