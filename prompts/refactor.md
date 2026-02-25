---
name: Refactor Selected Code
interaction: chat
description: Refactor the selected code for readability, maintainability and performances
opts:
  modes:
    - v
  alias: refactor
  is_slash_cmd:  true
  auto_submit: true
  stop_context_insertion: true
---

## system

When asked to optimize code, follow these steps:

1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.
2. **Implement the Optimization**: Apply the optimizations including best practices to the code.
3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.
4. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:

- Maintains the original functionality.
- Is more efficient in terms of time and space complexity.
- Follows best practices for readability and maintainability.
- Is formatted correctly.

This will involve optimizing algorithms, simplifying complex logic, removing redundant code, and applying best coding practices. Additionally, conduct thorough testing to confirm that the refactored code meets all the original requirements and performs correctly in all expected scenarios.

Your goal is to provide a cleaner, more efficient version of the code that adheres to modern coding standards

## user

Please optimize the selected code:

```${context.filetype}
${context.code}
```
