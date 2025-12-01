local utils = require('plugins.ai.codecompanion.utils')

local responseformat = [[<!-- markdownlint-disable MD041 MD013 MD040 MD031 -->

- Formatting Instructions:
  - Use Markdown formatting for all responses, including code blocks, lists, and inline code.
    - When providing code responses, ensure the code is concise and easy to read. Include only essential comments and handle only realistic edge cases.
  - Use fenced code blocks with language identifiers (e.g., ```lua).
    - When returning math blocks, set the language as `latex` instead of `math`.
    - Use $ instead of \( for inline math mode in LaTeX.
  - Do not use H1 (`#`) or H2 (`##`) headers in your responses.
  - Do not use any horizontal rules or lines made of dashes (e.g., `---`) anywhere in the response.
    - For example, do not include lines like:
      ```
      ---
      ```
    - If you need to separate sections, use blank lines instead.
  - Use actual line breaks in your responses; only use `\n` when you want a literal backslash followed by 'n'.
  - Prefer commas over dashes for clause separation and asides.
    - Example: “This function, which handles retries, should back off exponentially.”
    - Avoid: “This function—which handles retries—should back off exponentially.”
    - Em dashes are acceptable for emphasis, but use them sparingly, not for routine clause separation.]]

local prompt = [[<!-- markdownlint-disable MD041 MD013 MD031 MD036 MD029 -->
You are a release manager.

Given a list of git commit messages (subject and body), write a changelog entry in the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) style.

**Instructions:**
- For each commit, write a single, concise bullet point summarizing the main change.
- Group changes under the appropriate sections: "Added", "Changed", "Fixed", "Removed", etc.
- Do not repeat the same information in multiple sections.
- Do not include commit SHAs or author names.
- If possible, combine similar changes into a single bullet.
- If a section has no changes, omit it.

**Example:**
```markdown
### Added
- Introduced user authentication module.
- Added password reset functionality.

### Changed
- Updated the login page UI for better accessibility.

### Fixed
- Fixed crash on login page when credentials are missing.
```

Here are the commit messages (each separated by "---"):
```text
%s
```]]

local content = responseformat .. '\n\n' .. prompt

return {
  ['changelog'] = {
    description = 'Generate a changelog entry from git commit messages',
    callback = function(chat, opts)
      local git_root, err = utils.get_git_root()
      if not git_root then
        if err then
          vim.notify(err, vim.log.levels.ERROR)
        end
        return
      end

      local shas = opts and opts.commit_shas
      if not shas or vim.tbl_isempty(shas) then
        local tag = vim.trim(
          vim.system({ 'git', 'describe', '--tags', '--abbrev=0' }, { text = true, cwd = git_root }):wait().stdout or ''
        )
        if tag == '' then
          vim.notify('No release tag found!', vim.log.levels.WARN)
          return
        end

        shas = vim.split(
          vim.trim(
            -- Get all commit SHAs after the tag
            vim.system({ 'git', 'log', '--format=%H', tag .. '..HEAD' }, { text = true, cwd = git_root }):wait().stdout
              or ''
          ),
          '\n',
          { plain = true }
        )
        if vim.tbl_isempty(shas) or (vim.tbl_count(shas) == 1 and shas[1] == '') then
          vim.notify('No commits found after latest release!', vim.log.levels.WARN)
          return
        end
      end

      local commit_msgs = {}
      for _, sha in ipairs(shas) do
        local msg = vim.trim(
          vim.system({ 'git', 'show', '--no-patch', '--format=%B', sha }, { text = true, cwd = git_root }):wait().stdout
            or ''
        )
        local cleaned_msg = (msg:gsub('\n\n+', '\n\n'))
        table.insert(commit_msgs, cleaned_msg)
      end

      local joined = table.concat(commit_msgs, '\n---\n')
      chat:add_buf_message({
        role = 'user',
        content = string.format(content, joined),
      })
      chat:submit()
    end,
  },
}
