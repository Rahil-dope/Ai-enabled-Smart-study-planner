CREATE TABLE IF NOT EXISTS study_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id UUID REFERENCES goals(id) ON DELETE CASCADE,
  total_days INTEGER NOT NULL,
  hours_per_day INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS daily_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID REFERENCES study_plans(id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL,
  date DATE,
  subject_id UUID REFERENCES subjects(id) ON DELETE SET NULL,
  est_minutes INTEGER NOT NULL,
  is_completed BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID REFERENCES daily_tasks(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  is_completed BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  task_id UUID REFERENCES daily_tasks(id) ON DELETE SET NULL,
  minutes_spent INTEGER NOT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
