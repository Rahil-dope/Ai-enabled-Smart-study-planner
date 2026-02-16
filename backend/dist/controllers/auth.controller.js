"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.login = exports.register = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const db_1 = require("../db");
const generateTokens = (user) => {
    const accessToken = jsonwebtoken_1.default.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '15m' });
    const refreshToken = jsonwebtoken_1.default.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '7d' });
    return { accessToken, refreshToken };
};
const register = async (req, res) => {
    const { name, email, password } = req.body;
    try {
        const userCheck = await (0, db_1.query)('SELECT id FROM users WHERE email = $1', [email]);
        if (userCheck.rows.length > 0) {
            return res.status(400).json({ success: false, error: { code: 'EMAIL_EXISTS', message: 'Email already registered' } });
        }
        const hashedPassword = await bcryptjs_1.default.hash(password, 10);
        const result = await (0, db_1.query)('INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING id, name, email', [name, email, hashedPassword]);
        const user = result.rows[0];
        const tokens = generateTokens(user);
        res.status(201).json({ success: true, data: { user, ...tokens } });
    }
    catch (error) {
        console.error('Register error:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Registration failed' } });
    }
};
exports.register = register;
const login = async (req, res) => {
    const { email, password } = req.body;
    try {
        const result = await (0, db_1.query)('SELECT * FROM users WHERE email = $1', [email]);
        if (result.rows.length === 0) {
            return res.status(401).json({ success: false, error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' } });
        }
        const user = result.rows[0];
        const validPassword = await bcryptjs_1.default.compare(password, user.password_hash);
        if (!validPassword) {
            return res.status(401).json({ success: false, error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' } });
        }
        const tokens = generateTokens(user);
        // Remove password hash from response
        delete user.password_hash;
        res.json({ success: true, data: { user, ...tokens } });
    }
    catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Login failed' } });
    }
};
exports.login = login;
