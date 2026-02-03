-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- GitHub color scheme

    'projekt0n/github-nvim-theme',
    priority = 999,
    config = function()
      require('github-theme').setup {}
      vim.cmd.colorscheme 'github_dark_default'
    end,
  },

  { -- Autocompletion with LLM
    'milanglacier/minuet-ai.nvim',
    lazy = true,
    config = function()
      require('minuet').setup {
        blink = {
          enable_auto_complete = false,
        },
        virtualtext = {
          auto_trigger_ft = {},
          auto_trigger_ignore_ft = {},
          keymap = {
            accept = '<C-n>',
            accept_line = nil,
            accept_n_lines = nil,
            prev = nil,
            next = '<C-j>',
            dismiss = nil,
          },
          show_on_completion_menu = false,
        },
        provider = 'openai_compatible',
        context_window = 16000,
        throttle = 1000,
        debounce = 400,
        notify = 'verbose', -- 'debug', 'verbose', 'warn', 'error'
        request_timeout = 10,
        n_completions = 2,
        provider_options = {
          openai_compatible = {
            model = 'devstral:24b',
            stream = true,
            end_point = 'http://localhost:11434/v1/chat/completions',
            -- api_key = 'OLLAMA_API_KEY'
            name = 'Ollama',
            optional = {
              stop = nil,
              max_tokens = nil,
            },
          },
        },
      }
    end,
  },
}
