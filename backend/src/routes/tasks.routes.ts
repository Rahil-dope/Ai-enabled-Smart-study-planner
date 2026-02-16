import { Router } from 'express';
import { getTasks, updateTaskStatus } from '../controllers/tasks.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.use(authenticateToken);

router.get('/tasks', getTasks);
router.put('/tasks/:id', updateTaskStatus);

export default router;
