"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generatePlan = void 0;
const ai_service_1 = require("../services/ai.service");
const db_1 = require("../db");
// Actually, DB handles defaults, but for complex inserts we often need IDs back.
// Since we are doing nested inserts, we might need to be careful.
// Let's rely on RETURNING clauses.
const generatePlan = async (req, res) => {
    const { goalId, hoursPerDay, existingKnowledge } = req.body;
    const userId = req.user.id;
    if (!goalId || !hoursPerDay) {
        return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'Goal ID and hours per day required' } });
    }
    try {
        // 1. Fetch Goal Details
        const goalResult = await (0, db_1.query)('SELECT * FROM goals WHERE id = $1 AND user_id = $2', [goalId, userId]);
        if (goalResult.rows.length === 0) {
            return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Goal not found' } });
        }
        const goal = goalResult.rows[0];
        // 2. Call AI Service
        const aiPlan = await (0, ai_service_1.generateStudyPlan)(goal.title, hoursPerDay, existingKnowledge, goal.deadline);
        // 3. Save Study Plan
        const planResult = await (0, db_1.query)('INSERT INTO study_plans (goal_id, total_days, hours_per_day) VALUES ($1, $2, $3) RETURNING id', [goalId, aiPlan.totalDays, hoursPerDay]);
        const planId = planResult.rows[0].id;
        // 4. Save Daily Tasks and Topics (Serialized transaction would be better, but keeping simple for now)
        for (const day of aiPlan.schedule) {
            // Create/Find Subject (Inferred from focus or default)
            // For simplicity, we might skip subject linking here or create a "General" subject if not passed
            const taskResult = await (0, db_1.query)('INSERT INTO daily_tasks (plan_id, day_number, est_minutes) VALUES ($1, $2, $3) RETURNING id', [planId, day.day, day.estimatedMinutes]);
            const taskId = taskResult.rows[0].id;
            for (const topicName of day.topics) {
                await (0, db_1.query)('INSERT INTO topics (task_id, name) VALUES ($1, $2)', [taskId, topicName]);
            }
        }
        res.status(201).json({
            success: true,
            data: { planId, message: 'Study plan generated successfully', totalDays: aiPlan.totalDays }
        });
    }
    catch (error) {
        console.error('Plan Generation Error:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to generate plan' } });
    }
};
exports.generatePlan = generatePlan;
