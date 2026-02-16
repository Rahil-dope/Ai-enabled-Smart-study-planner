"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const dotenv_1 = __importDefault(require("dotenv"));
const db_1 = require("./db");
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
// Middleware
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Routes
const auth_routes_1 = __importDefault(require("./routes/auth.routes"));
const app_routes_1 = __importDefault(require("./routes/app.routes"));
const planner_routes_1 = __importDefault(require("./routes/planner.routes"));
app.use('/api/v1/auth', auth_routes_1.default);
app.use('/api/v1', app_routes_1.default);
app.use('/api/v1/ai', planner_routes_1.default);
// Health Check
app.get('/api/v1/health', async (req, res) => {
    try {
        const result = await (0, db_1.query)('SELECT NOW()');
        res.json({
            status: 'ok',
            message: 'Server is running',
            dbTime: result.rows[0].now
        });
    }
    catch (error) {
        console.error('Database connection error:', error);
        res.status(500).json({
            status: 'error',
            message: 'Database connection failed'
        });
    }
});
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
