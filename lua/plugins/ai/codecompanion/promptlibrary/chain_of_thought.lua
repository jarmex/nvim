return {
  ['Chain-of-Thought'] = {
    interaction = 'workflow',
    description = 'Use a CoT workflow to plan and write code',
    opts = {
      adapter = {
        name = 'copilot',
        model = 'gpt-5',
      },
    },
    prompts = {
      {
        {
          role = 'user',
          content = [[DO NOT WRITE ANY CODE YET.

Your task is to act as an expert software architect and create a comprehensive implementation plan.

First, think step-by-step. Then, provide a detailed pseudocode plan that outlines the solution.

Your plan should include:
1.  A high-level summary of the proposed approach.
2.  A breakdown of the required logic into sequential steps.
3.  Identification of any new functions, classes, or components that should be created.
4.  Consideration of how the changes will interact with existing code.
5.  A list of potential edge cases and error conditions to handle.

<!-- Be sure to share any relevant files -->
<!-- Your task here -->]],
          opts = {
            auto_submit = false,
          },
        },
      },
      {
        {
          role = 'user',
          content = [[Now, act as a senior technical lead reviewing the previous plan. Your goal is to refine it into a final, highly-detailed specification that another AI can implement flawlessly.

Critically evaluate the plan by answering the following questions:
1.  What are the strengths and weaknesses of the proposed approach?
2.  Are there any alternative approaches? If so, what are their trade-offs?
3.  What potential risks, edge cases, or dependencies did the initial plan miss?
4.  How can the pseudocode be made more specific and closer to the target language's syntax and conventions?

After your analysis, provide a final, revised pseudocode plan. This new plan should incorporate your improvements, be extremely detailed, and leave no room for ambiguity.]],
          opts = {
            adapter = {
              name = 'copilot',
              model = 'claude-sonnet-4',
            },
            auto_submit = true,
          },
        },
      },
      {
        {
          role = 'user',
          content = [[Your task is to write the code based on the final implementation plan that we discussed. Adhere strictly to the plan and do not introduce any new logic.

**Instructions:**
1.  Implement the plan.
2.  Generate only the code. Do not include explanations or conversational text.
3.  Use Markdown code blocks for the code (use 4 backticks instead of 3)
4.  If you are modifying an existing file, include a comment with its path (e.g., `// filepath: src/utils/helpers.js`).
5.  Use comments like `// ...existing code...` to indicate where the new code should be placed within existing files.

**IMPORTANT:**
- Follow the plan exactly.
- Ensure comments are correct for the programming language.]],
          opts = {
            adapter = {
              name = 'copilot',
              model = 'gpt-4.1',
            },
            auto_submit = true,
          },
        },
      },
    },
  },
}
