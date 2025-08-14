-- adapted from https://github.com/3ZsForInsomnia/dotfiles/blob/main/neovim/.config/nvim/lua/plugins/ai.lua

local dailyPlanningText = [[
You are my personal planning assistant. I will share notes from the day before, along with my current work tasks (from Jira) and personal tasks (from Trello).

Please:
- Review my notes from yesterday and my current tasks.
- Suggest what I should focus on and prioritize today, considering my goals and available time.
- Identify any unfinished items from yesterday that should be carried over.
- Recommend a realistic schedule for today, including work, personal, and health activities.
- Push me to address any avoidance or procrastination.
- Suggest one actionable tip to improve my productivity or well-being today.

Format your response in markdown with bullet points and clear sections:
1. **Priorities for Today**
2. **Carryover Tasks**
3. **Recommended Schedule**
4. **Accountability / Push**
5. **Productivity Tip**
]]

local dailyReviewText = [[
You are my personal productivity assistant. I will share notes I've edited today.

Please:
- Summarize the main themes and topics from today’s notes.
- Identify what went well or positive progress.
- Point out areas I should focus on or improve, and suggest next steps.
- Extract actionable items or todos, prioritizing health/physical activity/meal prep first, then job, then hobbies.
- Track these activities and goals:
  - Physical activity
  - Meal prep (chicken/veggies for the week, not breakfast)
  - Practice hacking and/or forensics
  - Reading
  - Cooking, diet, hobbies
- If any expected activities are missing from today’s notes, mention this.
- Highlight any vague or incomplete thoughts, and suggest how I could make my notes more useful for future reference.
- If I am making excuses or avoiding things I intend to do, call me out and push me to follow through.
- Suggest one introspective question for reflection.

Format your response in markdown with bullet points and clear sections:
1. **Summary**
2. **Wins / Progress**
3. **Areas to Improve / Focus**
4. **Action Items / Todos** (prioritized)
5. **Missing Topics / Gaps**
6. **Reflection Question**

If any context is unclear, ask for clarification.
]]

local weeklyReviewText = [[
You are my personal productivity assistant. I will share notes I've edited in the last week.

Please:
- Summarize main themes and recurring topics (even if they appear only 2–3 times).
- Identify what went well or positive progress.
- Point out areas to improve or focus on, and suggest next steps.
- Extract actionable items or todos, prioritizing health/physical activity/meal prep first, then job, then hobbies.
- Review my regular activities and goals:
  - Karate (2–3x/week)
  - Rucking (3x/week)
  - Cooking (meal prep: chicken/veggies for the week, not breakfast) (1–3x/week)
  - Practice hacking and/or forensics (2x/week)
  - Picking locks, learning knots, playing guitar
  - Eating according to my diet
  - Reading (nearly every day)
- If any of these activities are missing or underrepresented (e.g., missed physical activity more than 2x/week, didn’t meal prep at least once, didn’t practice hacking/forensics, didn’t read most days, ate poorly 2+ times), highlight this.
- If my notes contain vague or incomplete thoughts, or lack enough detail to “save my progress,” point this out and suggest improvements.
- If I am making excuses or avoiding things I intend to do, call me out and push me to follow through.
- If my weekly notes include a markdown table tracking activities/diet, summarize the table and note any gaps or patterns.
- Suggest one or two introspective questions for reflection.

Format your response in markdown with bullet points and clear sections:
1. **Summary**
2. **Wins / Progress**
3. **Areas to Improve / Focus**
4. **Action Items / Todos** (prioritized)
5. **Missing Topics / Gaps**
6. **Reflection Questions**

If any context is unclear, ask for clarification.
]]

return {
  ['DailyPlanning'] = {
    strategy = 'chat',
    description = "Plan out your day based on yesterday's notes and current tasks",
    opts = { index = 3, is_slash_cmd = true, auto_submit = false, short_name = 'plan_today' },
    prompts = { { role = 'user', content = dailyPlanningText } },
  },

  ['ReviewNotesDaily'] = {
    strategy = 'chat',
    description = 'Summarize and review notes for daily reflection',
    opts = {
      index = 1,
      is_slash_cmd = true,
      auto_submit = false,
      short_name = 'review_notes_daily',
    },
    prompts = {
      { role = 'user', content = dailyReviewText },
    },
  },
  ['ReviewNotesWeekly'] = {
    strategy = 'chat',
    description = 'Summarize and review notes for weekly reflection',
    opts = {
      index = 2,
      is_slash_cmd = true,
      auto_submit = false,
      short_name = 'review_notes_weekly',
    },
    prompts = {
      { role = 'user', content = weeklyReviewText },
    },
  },
}
