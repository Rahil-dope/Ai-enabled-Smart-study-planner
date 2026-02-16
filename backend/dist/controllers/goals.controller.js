"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getGoals = exports.createGoal = void 0;
const db_1 = require("../db");
const createGoal = async (req, res) => {
    const { title, description, deadline } = req.body;
    const userId = req.user.id;
    if (!title || !deadline) {
        return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'Title and deadline required' } });
    }
    try {
        const result = await (0, db_1.query)('INSERT INTO goals (user_id, title, description, deadline) VALUES ($1, $2, $3, $4) RETURNING *', [userId, title, description, deadline]);
        res.status(201).json({ success: true, data: result.rows[0] });
    }
    catch (error) {
        console.error('Error creating goal:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to create goal' } });
    }
};
exports.createGoal = createGoal;
const getGoals = async (req, res) => {
    const userId = req.user.id;
    try {
        const result = await (0, db_1.query)('SELECT * FROM goals WHERE user_id = $1 ORDER BY created_at DESC', [userId]);
        res.json({ success: true, data: result.rows });
    }
    catch (error) {
        console.error('Error fetching goals:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to fetch goals' } });
    }
};
exports.getGoals = getGoals;
