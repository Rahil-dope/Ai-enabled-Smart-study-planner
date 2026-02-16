"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateStudyPlan = void 0;
const openai_1 = __importDefault(require("openai"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const openai = new openai_1.default({
    apiKey: process.env.OPENAI_API_KEY,
});
const generateStudyPlan = async (goal, hoursPerDay, currentKnowledge = 'Beginner', deadline) => {
    const prompt = `
    You are an expert academic study planner. Create a structured study plan for the goal: "${goal}".
    Daily Study Time: ${hoursPerDay} hours/day.
    Current Level: ${currentKnowledge}.
    ${deadline ? `Target Deadline: ${deadline}` : 'Estimate the duration based on complexity.'}

    Output strictly valid JSON with no markdown. Format:
    {
      "totalDays": <int>,
      "schedule": [
        {
          "day": <int>,
          "focus": "<string summary>",
          "estimatedMinutes": <int>,
          "topics": ["<string topic 1>", "<string topic 2>"]
        }
      ]
    }
  `;
    try {
        const response = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a helpful study planning assistant that outputs strict JSON." },
                { role: "user", content: prompt }
            ],
            temperature: 0.7,
            response_format: { type: "json_object" }
        });
        const content = response.choices[0].message.content;
        if (!content)
            throw new Error('No content received from AI');
        const result = JSON.parse(content);
        return result;
    }
    catch (error) {
        console.error('AI Generation Error:', error);
        throw new Error('Failed to generate study plan');
    }
};
exports.generateStudyPlan = generateStudyPlan;
