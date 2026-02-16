import { Request, Response } from 'express';
import { query } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export const getSubjects = async (req: Request, res: Response) => {
    try {
        const result = await query('SELECT * FROM subjects ORDER BY name ASC');
        res.json({ success: true, data: result.rows });
    } catch (error) {
        console.error('Error fetching subjects:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to fetch subjects' } });
    }
};

export const createSubject = async (req: AuthRequest, res: Response) => {
    const { name, colorHex } = req.body;

    if (!name || !colorHex) {
        return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'Name and colorHex required' } });
    }

    try {
        const result = await query(
            'INSERT INTO subjects (name, color_hex) VALUES ($1, $2) RETURNING *',
            [name, colorHex]
        );
        res.status(201).json({ success: true, data: result.rows[0] });
    } catch (error: any) {
        if (error.code === '23505') { // Unique violation
            return res.status(409).json({ success: false, error: { code: 'DUPLICATE_ENTRY', message: 'Subject already exists' } });
        }
        console.error('Error creating subject:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to create subject' } });
    }
};
