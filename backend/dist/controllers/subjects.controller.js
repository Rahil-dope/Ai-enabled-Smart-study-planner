"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createSubject = exports.getSubjects = void 0;
const db_1 = require("../db");
const getSubjects = async (req, res) => {
    try {
        const result = await (0, db_1.query)('SELECT * FROM subjects ORDER BY name ASC');
        res.json({ success: true, data: result.rows });
    }
    catch (error) {
        console.error('Error fetching subjects:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to fetch subjects' } });
    }
};
exports.getSubjects = getSubjects;
const createSubject = async (req, res) => {
    const { name, colorHex } = req.body;
    if (!name || !colorHex) {
        return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'Name and colorHex required' } });
    }
    try {
        const result = await (0, db_1.query)('INSERT INTO subjects (name, color_hex) VALUES ($1, $2) RETURNING *', [name, colorHex]);
        res.status(201).json({ success: true, data: result.rows[0] });
    }
    catch (error) {
        if (error.code === '23505') { // Unique violation
            return res.status(409).json({ success: false, error: { code: 'DUPLICATE_ENTRY', message: 'Subject already exists' } });
        }
        console.error('Error creating subject:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to create subject' } });
    }
};
exports.createSubject = createSubject;
