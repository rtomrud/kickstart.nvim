-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Autocompletion with LLM
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        cmp = {
          enable_auto_complete = false,
        },
        virtualtext = {
          auto_trigger_ft = {
            -- '*'
          },
          keymap = {
            accept = '<C-y>',
            accept_line = nil,
            accept_n_lines = nil,
            prev = '<C-k>',
            next = '<C-j>',
            dismiss = nil,
          },
        },
        provider = 'openai_fim_compatible',
        context_window = 32000,
        throttle = 1000,
        debounce = 250,
        request_timeout = 10,
        n_completions = 3,
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:32b-base-q4_K_M',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = 'OLLAMA_API_KEY', -- Set to any arbitrary value for Ollama
            name = 'Ollama',
            stream = true,
            optional = {
              max_tokens = nil,
              stop = { '\n\n' },
              top_p = 0.8,
            },
          },
        },
      }
    end,
  },
}
