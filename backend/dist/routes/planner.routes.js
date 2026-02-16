"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const planner_controller_1 = require("../controllers/planner.controller");
const auth_middleware_1 = require("../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.post('/generate-plan', auth_middleware_1.authenticateToken, planner_controller_1.generatePlan);
exports.default = router;
