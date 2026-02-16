import { Response } from 'express';
import { query } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export const getDashboardStats = async (req: AuthRequest, res: Response) => {
    const userId = req.user.id;

    try {
        // 1. Tasks Completed Today (use day_number or is_completed + created context)
        const todayResult = await query(
            `SELECT COUNT(*) as count FROM daily_tasks dt
       JOIN study_plans sp ON dt.plan_id = sp.id
       JOIN goals g ON sp.goal_id = g.id
       WHERE g.user_id = $1 AND dt.is_completed = true 
       AND (dt.date IS NULL OR DATE(dt.date) = CURRENT_DATE)`,
            [userId]
        );

        // 2. Total Active Goals
        const goalsResult = await query(
            "SELECT COUNT(*) as count FROM goals WHERE user_id = $1 AND status = 'active'",
            [userId]
        );

        // 3. Total Study Minutes (completed tasks)
        const timeResult = await query(
            `SELECT COALESCE(SUM(dt.est_minutes), 0) as total_minutes FROM daily_tasks dt
         JOIN study_plans sp ON dt.plan_id = sp.id
         JOIN goals g ON sp.goal_id = g.id
         WHERE g.user_id = $1 AND dt.is_completed = true`,
            [userId]
        );

        // 4. Calculate streak (consecutive days with completed tasks)
        const streakResult = await query(
            `SELECT COUNT(DISTINCT DATE(dt.date)) as streak_days 
       FROM daily_tasks dt
       JOIN study_plans sp ON dt.plan_id = sp.id
       JOIN goals g ON sp.goal_id = g.id
       WHERE g.user_id = $1 AND dt.is_completed = true
       AND dt.date >= CURRENT_DATE - INTERVAL '30 days'`,
            [userId]
        );

        res.json({
            success: true,
            data: {
                tasksCompletedToday: parseInt(todayResult.rows[0].count),
                activeGoals: parseInt(goalsResult.rows[0].count),
                totalStudyMinutes: parseInt(timeResult.rows[0].total_minutes || '0'),
                streakDays: parseInt(streakResult.rows[0].streak_days || '0'),
            }
        });
    } catch (error) {
        console.error('Error fetching dashboard stats:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to fetch stats' } });
    }
};
