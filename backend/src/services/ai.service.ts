import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config();

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

export interface AIPlanResponse {
    totalDays: number;
    schedule: {
        day: number;
        focus: string;
        estimatedMinutes: number;
        topics: string[];
    }[];
}

export const generateStudyPlan = async (
    goal: string,
    hoursPerDay: number,
    currentKnowledge: string = 'Beginner',
    deadline?: string
): Promise<AIPlanResponse> => {
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
        if (!content) throw new Error('No content received from AI');

        const result = JSON.parse(content) as AIPlanResponse;
        return result;
    } catch (error) {
        console.error('AI Generation Error:', error);
        throw new Error('Failed to generate study plan');
    }
};
