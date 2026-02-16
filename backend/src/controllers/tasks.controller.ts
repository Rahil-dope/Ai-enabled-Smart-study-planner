import { Response } from 'express';
import { query } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export const getTasks = async (req: AuthRequest, res: Response) => {
    const { planId, goalId } = req.query;

    try {
        let result;
        if (planId) {
            result = await query(
                `SELECT dt.*, 
          (SELECT json_agg(t.*) FROM topics t WHERE t.task_id = dt.id) as topics
         FROM daily_tasks dt 
         WHERE dt.plan_id = $1 
         ORDER BY dt.day_number ASC`,
                [planId]
            );
        } else if (goalId) {
            result = await query(
                `SELECT dt.*, 
          (SELECT json_agg(t.*) FROM topics t WHERE t.task_id = dt.id) as topics
         FROM daily_tasks dt 
         JOIN study_plans sp ON dt.plan_id = sp.id
         WHERE sp.goal_id = $1
         ORDER BY dt.day_number ASC`,
                [goalId]
            );
        } else {
            return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'planId or goalId required' } });
        }

        res.json({ success: true, data: result.rows });
    } catch (error) {
        console.error('Error fetching tasks:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to fetch tasks' } });
    }
};

export const updateTaskStatus = async (req: AuthRequest, res: Response) => {
    const { id } = req.params;
    const { isCompleted } = req.body;

    try {
        const result = await query(
            'UPDATE daily_tasks SET is_completed = $1 WHERE id = $2 RETURNING *',
            [isCompleted, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Task not found' } });
        }

        // TODO: Update Progress table logic here (Module 9)

        res.json({ success: true, data: result.rows[0] });
    } catch (error) {
        console.error('Error updating task:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to update task' } });
    }
};
