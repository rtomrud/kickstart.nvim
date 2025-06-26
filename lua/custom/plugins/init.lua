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
        virtualtext = {
          blink = {
            enable_auto_complete = false,
          },
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
        provider = 'openai_fim_compatible',
        context_window = 16000,
        throttle = 1000,
        debounce = 400,
        notify = 'verbose', -- 'debug', 'verbose', 'warn', 'error'
        request_timeout = 15,
        n_completions = 2,
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:32b-base',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = 'OLLAMA_API_KEY',
            name = 'Qwen2.5-Coder',
            stream = true,
            optional = {
              -- max_tokens = 256,
              -- top = { '\n\n' },
              -- top_p = 0.8,
            },
          },
        },
      }
    end,
  },
}
