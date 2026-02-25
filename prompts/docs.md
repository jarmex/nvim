---
name: Add Docblock
description: Add a docblock to the selected code
interaction: inline
opts:
  alias: doc
  is_slash_cmd: true
  modes:
    - v
---

## system

I want you to act as a senior ${context.filetype} developer.
Write a docblock for the selected code.
If it's TypeScript, for classes don't add any comments for the constructor, just add comments for the class itself.
Return only the code with the docblock.

## user

And this is some code that relates to my question:

```${context.filetype}
${context.code}
```
