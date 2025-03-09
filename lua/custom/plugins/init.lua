-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- GitHub color scheme
    'projekt0n/github-nvim-theme',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('github-theme').setup {
        styles = {
          comments = { italic = true },
        },
      }
      vim.cmd.colorscheme 'github_dark_default'
    end,
  },

  { -- Autocompletion with LLM
    'milanglacier/minuet-ai.nvim',
    lazy = true,
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
        add_single_line_entry = true,
        provider = 'openai_fim_compatible',
        context_window = 4096, -- 32000
        throttle = 1000,
        debounce = 250,
        request_timeout = 15,
        n_completions = 3,
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:32b-base-q4_K_M',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = 'OLLAMA_API_KEY',
            name = 'Ollama',
            stream = true,
            template = {
              prompt = function(pref, suff)
                local prompt_message = ''
                local vectorcode_cacher = require('vectorcode.config').get_cacher_backend()
                for _, file in ipairs(vectorcode_cacher.query_from_cache(0)) do
                  prompt_message = prompt_message .. '<|file_sep|>' .. file.path .. '\n' .. file.document .. '\n'
                end
                return prompt_message .. '<|fim_prefix|>' .. pref .. '<|fim_suffix|>' .. suff .. '<|fim_middle|>'
              end,
              suffix = false,
            },
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

  { -- Code repository indexing
    'Davidyz/VectorCode',
    version = '*', -- optional, depending on whether you're on nightly or release
    build = 'pipx upgrade vectorcode', -- optional but recommended if you set `version = "*"`
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    config = function()
      require('vectorcode').setup {
        async_opts = {
          debounce = 10,
          events = { 'BufWritePost', 'InsertEnter', 'BufReadPost' },
          exclude_this = true,
          n_query = 1,
          notify = false,
          query_cb = require('vectorcode.utils').make_surrounding_lines_cb(-1),
          run_on_register = false,
          single_job = true,
          timeout_ms = 15000,
        },
        async_backend = 'lsp',
        exclude_this = true,
        n_query = 1,
        notify = true,
        timeout_ms = 5000,
        on_setup = {
          update = false, -- set to true to enable update when `setup` is called.
        },
      }

      vim.api.nvim_create_autocmd({ 'LspAttach' }, {
        callback = function(args)
          local vectorcode_cacher = require('vectorcode.config').get_cacher_backend()
          if not vectorcode_cacher.buf_is_registered(args.buf) then
            vectorcode_cacher.register_buffer(args.buf, {
              debounce = 10,
              events = { 'BufWritePost', 'InsertEnter', 'BufReadPost' },
              exclude_this = true,
              n_query = 1,
              notify = false,
              query_cb = require('vectorcode.utils').make_surrounding_lines_cb(-1),
              run_on_register = false,
              single_job = false,
              timeout_ms = 15000,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufDelete' }, {
        callback = function(args)
          local vectorcode_cacher = require('vectorcode.config').get_cacher_backend()
          if vectorcode_cacher.buf_is_registered(args.buf) then
            vectorcode_cacher.deregister_buffer(args.buf)
          end
        end,
      })
    end,
  },
}
