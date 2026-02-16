"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const goals_controller_1 = require("../controllers/goals.controller");
const subjects_controller_1 = require("../controllers/subjects.controller");
const auth_middleware_1 = require("../middleware/auth.middleware");
const router = (0, express_1.Router)();
// Protect all routes
router.use(auth_middleware_1.authenticateToken);
// Goals
router.post('/goals', goals_controller_1.createGoal);
router.get('/goals', goals_controller_1.getGoals);
// Subjects
router.post('/subjects', subjects_controller_1.createSubject);
router.get('/subjects', subjects_controller_1.getSubjects);
exports.default = router;
