return {
  filetypes = { 'gitcommit', 'html', 'markdown' },
  capabilities = Helpers.lsp.create_capabilities(),
  settings = {
    ['harper-ls'] = {
      codeActions = {
        forceStable = true,
      },
      linters = {
        spell_check = true,
        spelled_numbers = false,
        an_a = true,
        sentence_capitalization = false,
        unclosed_quotes = true,
        wrong_quotes = false,
        long_sentences = false,
        repeated_words = true,
        spaces = true,
        matcher = true,
        linking_verbs = false,
        boring_words = true,
        capitalize_personal_pronouns = true,
        oxford_comma = true,
        avoid_curses = true,
        merge_words = true,
        plural_conjugate = true,
      },
      -- isolateEnglish = false,
    },
  },
}
