import { Router } from 'express';
import { register, login } from '../controllers/auth.controller';
import { authenticateToken, AuthRequest } from '../middleware/auth.middleware';

const router = Router();

router.post('/register', register);
router.post('/login', login);

router.get('/me', authenticateToken, (req: AuthRequest, res) => {
    res.json({ success: true, data: { user: req.user } });
});

export default router;
