-- from https://github.com/3ZsForInsomnia/dotfiles/blob/b9592b901be95d3ee74386fe4eb42ff20749ce6a/neovim/.config/nvim/lua/config/prompts/vectorcode.lua
-- VectorCode retrieval prompts (consolidated to 3 prompts)
--
-- 1. Inline: Extract keywords & query - local LLM extracts keywords, queries, returns results
-- 2. Chat: Search with summary - remote LLM with summary + sources format
-- 3. Chat: Raw file listing - remote LLM with minimal file list
--
-- Chat prompts use route charter for multi-collection support.
-- All chat prompts use remote adapter and don't auto-submit.

local remote_adapter = { name = 'default_copilot' }
-- Sources section format for VectorCode-enhanced prompts
local sources_format = [[

## Sources
Cite all VectorCode results and referenced files using footnotes:
[^1]: path/to/file.md
  - Brief description of content
  - Why it's relevant to this context
  - (1-3 bullets total per source)
]]
--------------------------------------------------
-- Inline: Extract Keywords & Query
--------------------------------------------------
local vc_extract_keywords_text = [[
Extract 3-6 relevant keywords from the provided text and search for related content.

Query parameters:
- num=4
- chunk_mode=true

Output format:
Keywords: <comma-separated keywords>

File paths:
- <path/to/file1>
- <path/to/file2>
- ...

Summary:
<Brief summary of findings from the retrieved chunks>
]]

local vc_extract_keywords = {
  strategy = 'inline',
  description = 'VectorCode: Extract keywords from selection and query',
  opts = { placement = 'new' },
  prompts = {
    { role = 'user', content = vc_extract_keywords_text },
  },
}

--------------------------------------------------
-- Chat: Search with Summary
--------------------------------------------------
local vc_search_summary_text = 'Search for relevant context based on my query.\n\n'
  .. '#{vccharter}#{vccurrproj}#{vcnotes}\n\n'
  .. 'Use chunk_mode=true for more granular results.\n\n'
  .. 'Provide:\n'
  .. '1. A concise summary synthesizing the retrieved content\n'
  .. '2. Create inline wiki-links [[path/to/file]] where relevant\n'
  .. sources_format

local vc_search_summary = {
  strategy = 'chat',
  description = 'VectorCode: Search with summary and sources',
  opts = {
    adapter = remote_adapter,
    auto_submit = false,
  },
  prompts = {
    { role = 'user', content = vc_search_summary_text },
  },
}

--------------------------------------------------
-- Chat: Raw File Listing
--------------------------------------------------
local vc_search_raw_text = 'Search for files and return a minimal listing (no summary, no contents).\n\n'
  .. '#{vccharter}#{vccurrproj}#{vcnotes}\n\n'
  .. 'Return just file paths with one-line descriptions.\n'
  .. 'Create inline wiki-links [[path/to/file]].\n'
  .. sources_format

local vc_search_raw = {
  strategy = 'chat',
  description = 'VectorCode: Raw file listing',
  opts = {
    adapter = remote_adapter,
    auto_submit = false,
  },
  prompts = {
    { role = 'user', content = vc_search_raw_text },
  },
}

return {
  ['VectorCode Extract Keywords'] = vc_extract_keywords,
  ['VectorCode Search with Summary'] = vc_search_summary,
  ['VectorCode Raw File Listing'] = vc_search_raw,
}
