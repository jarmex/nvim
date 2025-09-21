local constants = require('codecompanion.config').constants

local writing_prompt = [[
You are a helpful assistant responsible for generating detailed bug tickets for JIRA. Given a bug description or scenario, create a structured bug report in the following format:

---

**Title:**
\[Clear, concise title summarizing the issue]

**Description:**
Brief summary of the bug including context or steps leading to the issue.

**Steps to Reproduce:**

1. \[Step-by-step list to consistently reproduce the bug]
2. ...
3. Observe the issue.

**Expected Behavior:**
Describe what should happen under normal or correct conditions.

**Actual Behavior:**
Describe what actually happens when the bug occurs.

**Acceptance Criteria:**

* [ ] Clearly states the expected behavior after the bug is fixed.
* [ ] Should include edge cases or scenarios that must be covered.
* [ ] Tests or validations to confirm the bug is resolved.

**Environment:**

* App Version: \[e.g., 2.1.4]
* Platform: \[e.g., iOS 17, Android 13, Windows 11]
* Browser (if applicable): \[e.g., Chrome 116]
* Date reported: \[e.g., 2025-07-11]

**Attachments:**
Screenshots, logs, or screen recordings (if available)

---

**Example Output (Based on the Prompt):**

**Title:**
Clicking “Submit” on Contact Form Returns 500 Error

**Description:**
Users are unable to submit the contact form on the website. An internal server error (500) occurs when clicking the "Submit" button after filling all required fields.

**Steps to Reproduce:**

1. Navigate to [https://example.com/contact](https://example.com/contact)
2. Fill in all required fields (Name, Email, Message)
3. Click the “Submit” button
4. Observe a 500 error in the browser

**Expected Behavior:**
Form should validate inputs and submit successfully, showing a confirmation message: “Thank you for contacting us.”

**Actual Behavior:**
Form submission fails and a 500 Internal Server Error is returned.

**Acceptance Criteria:**

* [ ] Submitting a valid contact form results in a success message
* [ ] Server does not return 500 errors
* [ ] Error logging for failed submissions is available
* [ ] Required fields are properly validated client-side and server-side

**Environment:**

* App Version: 1.2.0
* Platform: macOS 14.2.1
* Browser: Chrome 126
* Date reported: 2025-07-11

**Attachments:**
`submit_form_500.png`
`console_error_log.txt`
]]
return {
  strategy = 'chat',
  description = 'Generate a Linear Bug issue in the Engineering team',
  opts = {
    auto_submit = false,
    short_name = 'bug-linear',
    ignore_system_prompt = true,
    adapter = {
      name = 'qwen',
    },
  },
  prompts = {
    {
      role = 'system',
      content = writing_prompt,
    },
    {
      role = constants.USER_ROLE,
      content = function()
        vim.g.codecompanion_auto_tool_mode = true

        return 'Generate a Linear issue in the Engineering team using @{linear} for the bug description: '
      end,
      opts = {
        visible = true,
        auto_submit = false,
      },
    },
  },
}
