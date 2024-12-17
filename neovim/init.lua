-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- stuff to show the current mode
vim.opt.showmode = false

-- vim clipboard stuff 
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
 { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Alright, now for non-standard plugins
  -- mini.files
  {
  "echasnovski/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 30,
    },
    options = {
      -- Whether to use for editing directories
      -- Disabled by default in LazyVim because neo-tree is used for that
      use_as_default_explorer = true,
    },
  },
  keys = {
    {
      "<leader>fm",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>fM",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    local show_dotfiles = true
    local filter_show = function(fs_entry)
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require("mini.files").refresh({ content = { filter = new_filter } })
    end

    local map_split = function(buf_id, lhs, direction, close_on_file)
      local rhs = function()
        local new_target_window
        local cur_target_window = require("mini.files").get_explorer_state().target_window
        if cur_target_window ~= nil then
          vim.api.nvim_win_call(cur_target_window, function()
            vim.cmd("belowright " .. direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
          end)

          require("mini.files").set_target_window(new_target_window)
          require("mini.files").go_in({ close_on_file = close_on_file })
        end
      end

      local desc = "Open in " .. direction .. " split"
      if close_on_file then
        desc = desc .. " and close"
      end
      vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    local files_set_cwd = function()
      local cur_entry_path = MiniFiles.get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      if cur_directory ~= nil then
        vim.fn.chdir(cur_directory)
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        vim.keymap.set(
          "n",
          opts.mappings and opts.mappings.toggle_hidden or "g.",
          toggle_dotfiles,
          { buffer = buf_id, desc = "Toggle hidden files" }
        )

        vim.keymap.set(
          "n",
          opts.mappings and opts.mappings.change_cwd or "gc",
          files_set_cwd,
          { buffer = args.data.buf_id, desc = "Set cwd" }
        )

        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-w>s", "horizontal", false)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-w>v", "vertical", false)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-w>S", "horizontal", true)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-w>V", "vertical", true)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        LazyVim.lsp.on_rename(event.data.from, event.data.to)
      end,
    })
  end,
  },
  -- Theme = sphere's vague theme
  {
  "vague2k/vague.nvim",
  opts = {},
  cfnfig = function()
    require("vague").setup({
    -- optional configuration here
      transparent = true,
      style = {
      -- "none" is the same thing as default. But "italic" and "bold" are also valid options
        boolean = "none",
        number = "none",
        float = "none",
        error = "none",
        comments = "none",
        conditionals = "none",
        functions = "none",
        headings = "bold",
        operators = "none",
        strings = "none",
        variables = "none",

        -- keywords
        keywords = "none",
        keyword_return = "none",
        keywords_loop = "none",
        keywords_label = "none",
        keywords_exception = "none",

        -- builtin
        builtin_constants = "none",
        builtin_functions = "none",
        builtin_types = "none",
        builtin_variables = "none",
      },
      colors = {
      func = "#bc96b0",
      keyword = "#787bab",
      -- string = "#d4bd98",
      string = "#8a739a",
                                    -- string = "#f2e6ff",
                                    -- number = "#f2e6ff",
                                    -- string = "#d8d5b1",
      number = "#8f729e",
                                    -- type = "#dcaed7",
      },
    })
  end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' }    
  },
  {
	"goolord/alpha-nvim",
        opts = {},
	dependencies = {
		"echasnovski/mini.icons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.opts.hl = {
			{
				{ "I2A0", 0, 3 },
				{ "I2A0", 3, 6 },
				{ "I2A0", 6, 9 },
				{ "I2A0", 9, 12 },
				{ "I2A0", 12, 15 },
				{ "I2A0", 15, 18 },
				{ "I2A0", 18, 21 },
				{ "I2A0", 21, 24 },
				{ "I2A0", 24, 27 },
				{ "I2A0", 27, 30 },
				{ "I2A0", 30, 33 },
				{ "I2A0", 33, 36 },
				{ "I2A0", 36, 39 },
				{ "I2A0", 39, 42 },
				{ "I2A0", 42, 45 },
				{ "I2A0", 45, 48 },
				{ "I2A0", 48, 51 },
				{ "I2A0", 51, 54 },
				{ "I2A0", 54, 57 },
				{ "I2A0", 57, 60 },
				{ "I2A0", 60, 63 },
				{ "I2A0", 63, 66 },
				{ "I2A0", 66, 69 },
				{ "I2A0", 69, 72 },
				{ "I2A0", 72, 75 },
				{ "I2A0", 75, 78 },
				{ "I2A0", 78, 81 },
				{ "I2A0", 81, 84 },
				{ "I2A0", 84, 87 },
				{ "I2A0", 87, 90 },
				{ "I2A0", 90, 93 },
				{ "I2A0", 93, 96 },
				{ "I2A0", 96, 99 },
				{ "I2A0", 99, 102 },
				{ "I2A0", 102, 105 },
				{ "I2A0", 105, 108 },
				{ "I2A0", 108, 111 },
			},
			{
				{ "I2A1", 0, 3 },
				{ "I2A2", 3, 6 },
				{ "I2A2", 6, 9 },
				{ "I2A2", 9, 12 },
				{ "I2A2", 12, 15 },
				{ "I2A2", 15, 18 },
				{ "I2A2", 18, 21 },
				{ "I2A2", 21, 24 },
				{ "I2A2", 24, 27 },
				{ "I2A2", 27, 30 },
				{ "I2A2", 30, 33 },
				{ "I2A2", 33, 36 },
				{ "I2A2", 36, 39 },
				{ "I2A3", 39, 42 },
				{ "I2A4", 42, 45 },
				{ "I2A5", 45, 48 },
				{ "I2A6", 48, 51 },
				{ "I2A7", 51, 54 },
				{ "I2A8", 54, 57 },
				{ "I2A4", 57, 60 },
				{ "I2A9", 60, 63 },
				{ "I2A2", 63, 66 },
				{ "I2A2", 66, 69 },
				{ "I2A10", 69, 72 },
				{ "I2A2", 72, 75 },
				{ "I2A2", 75, 78 },
				{ "I2A2", 78, 81 },
				{ "I2A2", 81, 84 },
				{ "I2A2", 84, 87 },
				{ "I2A2", 87, 90 },
				{ "I2A2", 90, 93 },
				{ "I2A2", 93, 96 },
				{ "I2A11", 96, 99 },
				{ "I2A12", 99, 102 },
				{ "I2A12", 102, 105 },
				{ "I2A13", 105, 108 },
				{ "I2A12", 108, 111 },
			},
			{
				{ "I2A2", 0, 3 },
				{ "I2A2", 3, 6 },
				{ "I2A2", 6, 9 },
				{ "I2A2", 9, 12 },
				{ "I2A2", 12, 15 },
				{ "I2A2", 15, 18 },
				{ "I2A2", 18, 21 },
				{ "I2A2", 21, 24 },
				{ "I2A2", 24, 27 },
				{ "I2A2", 27, 30 },
				{ "I2A2", 30, 33 },
				{ "I2A2", 33, 36 },
				{ "I2A14", 36, 39 },
				{ "I2A15", 39, 42 },
				{ "I2A16", 42, 45 },
				{ "I2A17", 45, 48 },
				{ "I2A2", 48, 51 },
				{ "I2A2", 51, 54 },
				{ "I2A18", 54, 57 },
				{ "I2A19", 57, 60 },
				{ "I2A20", 60, 63 },
				{ "I2A21", 63, 66 },
				{ "I2A2", 66, 69 },
				{ "I2A2", 69, 72 },
				{ "I2A22", 72, 75 },
				{ "I2A22", 75, 78 },
				{ "I2A2", 78, 81 },
				{ "I2A2", 81, 84 },
				{ "I2A2", 84, 87 },
				{ "I2A23", 87, 90 },
				{ "I2A2", 90, 93 },
				{ "I2A2", 93, 96 },
				{ "I2A2", 96, 99 },
				{ "I2A2", 99, 102 },
				{ "I2A2", 102, 105 },
				{ "I2A2", 105, 108 },
				{ "I2A2", 108, 111 },
			},
			{
				{ "I2A24", 0, 3 },
				{ "I2A25", 3, 6 },
				{ "I2A2", 6, 9 },
				{ "I2A2", 9, 12 },
				{ "I2A2", 12, 15 },
				{ "I2A2", 15, 18 },
				{ "I2A2", 18, 21 },
				{ "I2A2", 21, 24 },
				{ "I2A2", 24, 27 },
				{ "I2A2", 27, 30 },
				{ "I2A2", 30, 33 },
				{ "I2A26", 33, 36 },
				{ "I2A27", 36, 39 },
				{ "I2A27", 39, 42 },
				{ "I2A28", 42, 45 },
				{ "I2A29", 45, 48 },
				{ "I2A30", 48, 51 },
				{ "I2A31", 51, 54 },
				{ "I2A32", 54, 57 },
				{ "I2A33", 57, 60 },
				{ "I2A34", 60, 63 },
				{ "I2A35", 63, 66 },
				{ "I2A27", 66, 69 },
				{ "I2A36", 69, 72 },
				{ "I2A2", 72, 75 },
				{ "I2A2", 75, 78 },
				{ "I2A37", 78, 81 },
				{ "I2A38", 81, 84 },
				{ "I2A2", 84, 87 },
				{ "I2A2", 87, 90 },
				{ "I2A2", 90, 93 },
				{ "I2A2", 93, 96 },
				{ "I2A2", 96, 99 },
				{ "I2A2", 99, 102 },
				{ "I2A38", 102, 105 },
				{ "I2A22", 105, 108 },
				{ "I2A39", 108, 111 },
			},
			{
				{ "I2A40", 0, 3 },
				{ "I2A41", 3, 6 },
				{ "I2A42", 6, 9 },
				{ "I2A43", 9, 12 },
				{ "I2A40", 12, 15 },
				{ "I2A42", 15, 18 },
				{ "I2A44", 18, 21 },
				{ "I2A45", 21, 24 },
				{ "I2A46", 24, 27 },
				{ "I2A46", 27, 30 },
				{ "I2A46", 30, 33 },
				{ "I2A27", 33, 36 },
				{ "I2A27", 36, 39 },
				{ "I2A47", 39, 42 },
				{ "I2A48", 42, 45 },
				{ "I2A2", 45, 48 },
				{ "I2A2", 48, 51 },
				{ "I2A1", 51, 54 },
				{ "I2A2", 54, 57 },
				{ "I2A2", 57, 60 },
				{ "I2A49", 60, 63 },
				{ "I2A50", 63, 66 },
				{ "I2A47", 66, 69 },
				{ "I2A7", 69, 72 },
				{ "I2A51", 72, 75 },
				{ "I2A52", 75, 78 },
				{ "I2A52", 78, 81 },
				{ "I2A53", 81, 84 },
				{ "I2A54", 84, 87 },
				{ "I2A55", 87, 90 },
				{ "I2A56", 90, 93 },
				{ "I2A57", 93, 96 },
				{ "I2A2", 96, 99 },
				{ "I2A58", 99, 102 },
				{ "I2A59", 102, 105 },
				{ "I2A60", 105, 108 },
				{ "I2A61", 108, 111 },
			},
			{
				{ "I2A62", 0, 3 },
				{ "I2A62", 3, 6 },
				{ "I2A63", 6, 9 },
				{ "I2A63", 9, 12 },
				{ "I2A63", 12, 15 },
				{ "I2A62", 15, 18 },
				{ "I2A64", 18, 21 },
				{ "I2A63", 21, 24 },
				{ "I2A64", 24, 27 },
				{ "I2A62", 27, 30 },
				{ "I2A65", 30, 33 },
				{ "I2A66", 33, 36 },
				{ "I2A67", 36, 39 },
				{ "I2A68", 39, 42 },
				{ "I2A69", 42, 45 },
				{ "I2A70", 45, 48 },
				{ "I2A2", 48, 51 },
				{ "I2A2", 51, 54 },
				{ "I2A71", 54, 57 },
				{ "I2A50", 57, 60 },
				{ "I2A50", 60, 63 },
				{ "I2A72", 63, 66 },
				{ "I2A73", 66, 69 },
				{ "I2A74", 69, 72 },
				{ "I2A75", 72, 75 },
				{ "I2A75", 75, 78 },
				{ "I2A76", 78, 81 },
				{ "I2A77", 81, 84 },
				{ "I2A50", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A78", 90, 93 },
				{ "I2A79", 93, 96 },
				{ "I2A80", 96, 99 },
				{ "I2A81", 99, 102 },
				{ "I2A82", 102, 105 },
				{ "I2A83", 105, 108 },
				{ "I2A84", 108, 111 },
			},
			{
				{ "I2A83", 0, 3 },
				{ "I2A83", 3, 6 },
				{ "I2A85", 6, 9 },
				{ "I2A86", 9, 12 },
				{ "I2A87", 12, 15 },
				{ "I2A88", 15, 18 },
				{ "I2A87", 18, 21 },
				{ "I2A89", 21, 24 },
				{ "I2A90", 24, 27 },
				{ "I2A91", 27, 30 },
				{ "I2A92", 30, 33 },
				{ "I2A93", 33, 36 },
				{ "I2A94", 36, 39 },
				{ "I2A95", 39, 42 },
				{ "I2A96", 42, 45 },
				{ "I2A97", 45, 48 },
				{ "I2A98", 48, 51 },
				{ "I2A99", 51, 54 },
				{ "I2A100", 54, 57 },
				{ "I2A69", 57, 60 },
				{ "I2A101", 60, 63 },
				{ "I2A75", 63, 66 },
				{ "I2A102", 66, 69 },
				{ "I2A103", 69, 72 },
				{ "I2A104", 72, 75 },
				{ "I2A105", 75, 78 },
				{ "I2A50", 78, 81 },
				{ "I2A106", 81, 84 },
				{ "I2A50", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A50", 90, 93 },
				{ "I2A107", 93, 96 },
				{ "I2A50", 96, 99 },
				{ "I2A108", 99, 102 },
				{ "I2A83", 102, 105 },
				{ "I2A109", 105, 108 },
				{ "I2A109", 108, 111 },
			},
			{
				{ "I2A98", 0, 3 },
				{ "I2A110", 3, 6 },
				{ "I2A98", 6, 9 },
				{ "I2A98", 9, 12 },
				{ "I2A111", 12, 15 },
				{ "I2A112", 15, 18 },
				{ "I2A113", 18, 21 },
				{ "I2A27", 21, 24 },
				{ "I2A27", 24, 27 },
				{ "I2A27", 27, 30 },
				{ "I2A27", 30, 33 },
				{ "I2A114", 33, 36 },
				{ "I2A75", 36, 39 },
				{ "I2A75", 39, 42 },
				{ "I2A115", 42, 45 },
				{ "I2A116", 45, 48 },
				{ "I2A117", 48, 51 },
				{ "I2A115", 51, 54 },
				{ "I2A118", 54, 57 },
				{ "I2A75", 57, 60 },
				{ "I2A119", 60, 63 },
				{ "I2A120", 63, 66 },
				{ "I2A50", 66, 69 },
				{ "I2A50", 69, 72 },
				{ "I2A50", 72, 75 },
				{ "I2A50", 75, 78 },
				{ "I2A50", 78, 81 },
				{ "I2A50", 81, 84 },
				{ "I2A50", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A50", 90, 93 },
				{ "I2A50", 93, 96 },
				{ "I2A50", 96, 99 },
				{ "I2A121", 99, 102 },
				{ "I2A122", 102, 105 },
				{ "I2A123", 105, 108 },
				{ "I2A110", 108, 111 },
			},
			{
				{ "I2A98", 0, 3 },
				{ "I2A98", 3, 6 },
				{ "I2A98", 6, 9 },
				{ "I2A124", 9, 12 },
				{ "I2A125", 12, 15 },
				{ "I2A126", 15, 18 },
				{ "I2A27", 18, 21 },
				{ "I2A127", 21, 24 },
				{ "I2A128", 24, 27 },
				{ "I2A129", 27, 30 },
				{ "I2A130", 30, 33 },
				{ "I2A75", 33, 36 },
				{ "I2A75", 36, 39 },
				{ "I2A75", 39, 42 },
				{ "I2A131", 42, 45 },
				{ "I2A132", 45, 48 },
				{ "I2A75", 48, 51 },
				{ "I2A75", 51, 54 },
				{ "I2A75", 54, 57 },
				{ "I2A133", 57, 60 },
				{ "I2A134", 60, 63 },
				{ "I2A134", 63, 66 },
				{ "I2A134", 66, 69 },
				{ "I2A134", 69, 72 },
				{ "I2A135", 72, 75 },
				{ "I2A136", 75, 78 },
				{ "I2A50", 78, 81 },
				{ "I2A50", 81, 84 },
				{ "I2A137", 84, 87 },
				{ "I2A138", 87, 90 },
				{ "I2A139", 90, 93 },
				{ "I2A50", 93, 96 },
				{ "I2A140", 96, 99 },
				{ "I2A50", 99, 102 },
				{ "I2A141", 102, 105 },
				{ "I2A142", 105, 108 },
				{ "I2A143", 108, 111 },
			},
			{
				{ "I2A98", 0, 3 },
				{ "I2A98", 3, 6 },
				{ "I2A144", 6, 9 },
				{ "I2A145", 9, 12 },
				{ "I2A146", 12, 15 },
				{ "I2A147", 15, 18 },
				{ "I2A50", 18, 21 },
				{ "I2A50", 21, 24 },
				{ "I2A50", 24, 27 },
				{ "I2A50", 27, 30 },
				{ "I2A148", 30, 33 },
				{ "I2A149", 33, 36 },
				{ "I2A150", 36, 39 },
				{ "I2A130", 39, 42 },
				{ "I2A75", 42, 45 },
				{ "I2A75", 45, 48 },
				{ "I2A75", 48, 51 },
				{ "I2A151", 51, 54 },
				{ "I2A152", 54, 57 },
				{ "I2A153", 57, 60 },
				{ "I2A154", 60, 63 },
				{ "I2A2", 63, 66 },
				{ "I2A155", 66, 69 },
				{ "I2A156", 69, 72 },
				{ "I2A157", 72, 75 },
				{ "I2A158", 75, 78 },
				{ "I2A50", 78, 81 },
				{ "I2A50", 81, 84 },
				{ "I2A50", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A50", 90, 93 },
				{ "I2A50", 93, 96 },
				{ "I2A50", 96, 99 },
				{ "I2A159", 99, 102 },
				{ "I2A50", 102, 105 },
				{ "I2A160", 105, 108 },
				{ "I2A161", 108, 111 },
			},
			{
				{ "I2A98", 0, 3 },
				{ "I2A162", 3, 6 },
				{ "I2A163", 6, 9 },
				{ "I2A164", 9, 12 },
				{ "I2A50", 12, 15 },
				{ "I2A165", 15, 18 },
				{ "I2A50", 18, 21 },
				{ "I2A50", 21, 24 },
				{ "I2A50", 24, 27 },
				{ "I2A50", 27, 30 },
				{ "I2A50", 30, 33 },
				{ "I2A166", 33, 36 },
				{ "I2A134", 36, 39 },
				{ "I2A75", 39, 42 },
				{ "I2A75", 42, 45 },
				{ "I2A167", 45, 48 },
				{ "I2A168", 48, 51 },
				{ "I2A169", 51, 54 },
				{ "I2A170", 54, 57 },
				{ "I2A171", 57, 60 },
				{ "I2A1", 60, 63 },
				{ "I2A172", 63, 66 },
				{ "I2A173", 66, 69 },
				{ "I2A174", 69, 72 },
				{ "I2A75", 72, 75 },
				{ "I2A75", 75, 78 },
				{ "I2A175", 78, 81 },
				{ "I2A50", 81, 84 },
				{ "I2A50", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A50", 90, 93 },
				{ "I2A50", 93, 96 },
				{ "I2A176", 96, 99 },
				{ "I2A177", 99, 102 },
				{ "I2A178", 102, 105 },
				{ "I2A179", 105, 108 },
				{ "I2A180", 108, 111 },
			},
			{
				{ "I2A98", 0, 3 },
				{ "I2A98", 3, 6 },
				{ "I2A181", 6, 9 },
				{ "I2A182", 9, 12 },
				{ "I2A183", 12, 15 },
				{ "I2A184", 15, 18 },
				{ "I2A50", 18, 21 },
				{ "I2A50", 21, 24 },
				{ "I2A185", 24, 27 },
				{ "I2A50", 27, 30 },
				{ "I2A50", 30, 33 },
				{ "I2A50", 33, 36 },
				{ "I2A186", 36, 39 },
				{ "I2A187", 39, 42 },
				{ "I2A188", 42, 45 },
				{ "I2A189", 45, 48 },
				{ "I2A190", 48, 51 },
				{ "I2A191", 51, 54 },
				{ "I2A192", 54, 57 },
				{ "I2A193", 57, 60 },
				{ "I2A194", 60, 63 },
				{ "I2A195", 63, 66 },
				{ "I2A196", 66, 69 },
				{ "I2A197", 69, 72 },
				{ "I2A198", 72, 75 },
				{ "I2A95", 75, 78 },
				{ "I2A50", 78, 81 },
				{ "I2A50", 81, 84 },
				{ "I2A199", 84, 87 },
				{ "I2A50", 87, 90 },
				{ "I2A50", 90, 93 },
				{ "I2A200", 93, 96 },
				{ "I2A201", 96, 99 },
				{ "I2A202", 99, 102 },
				{ "I2A203", 102, 105 },
				{ "I2A204", 105, 108 },
				{ "I2A204", 108, 111 },
			},
		}

		dashboard.section.header.val = {
			[[ ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⠀⡀⢀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
			[[ ⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣽⠃⠀⠀⠀⢼⠻⣿⣿⣟⣿⣿⣿⣿⣶⣶⣶⣶⣤⣤⣤⣤⣤ ]],
			[[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠛⡶⢶⢺⠁⠀⠈⢿⣿⣿⣿⣿⣿⣿⣏⣿⣿⣿⣿⣿⣿⣿ ]],
			[[ ⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⣤⠀⣀⣠⡛⣣⡀⠀⠈⢿⣿⣿⣻⣏⣿⣿⣿⣿⣿⣿⣟⣿⠿ ]],
			[[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⣳⣶⣿⣿⣷⣾⠱⠀⠀⠊⢿⠿⠿⢛⣽⣿⡿⢿⣿⣟⠿⠿⠿ ]],
			[[ ⠉⠉⠉⠛⠛⠛⠋⠛⠛⠛⣧⠀⡀⠀⠀⢿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠅⢀⢀⡀ ]],
			[[ ⠔⠄⢀⡀⠀⠀⠀⠄⠐⠸⠿⡀⠀⠀⠀⢘⣿⢷⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠰⣠⣇ ]],
			[[ ⣷⣆⣴⣮⢻⡲⡲⠀⠁⠀⠀⠀⠀⠀⠀⠹⡿⠘⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣀⡘⢷⣏ ]],
			[[ ⣿⣿⣿⣗⠿⢈⠁⡀⠀⠁⠀⠀⠀⠀⠀⠀⠉⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⠄⠀⠄⠈⢿⣮⢿ ]],
			[[ ⣿⣟⡿⣾⠀⠀⠀⠀⠀⠀⠀⢀⡤⠄⠀⠀⠀⠀⠸⠁⢠⣦⣤⢀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠈⣿⠀ ]],
			[[ ⣿⣿⠏⠁⢀⡇⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠘⡏⣷⣵⡻⠃⠄⢴⣆⠀⠀⠀⠀⠀⠀⠀⠰⠀⣆⣷⣿ ]],
			[[ ⣿⡿⣻⠗⠀⢠⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⢠⣤⣄⢰⣶⢯⣤⡈⠋⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⣿⣼ ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("b", "  > Browse files", ":Oil --float<CR>"),
			dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
		}

		alpha.setup(dashboard.opts)
	end,
  },
  {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {},
	config = function()
		require("render-markdown").setup({})
	end,
          -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
          -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
          dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you prefer nvim-web-devicons
  },
  {
  "windwp/nvim-autopairs",
  opts = {},
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({})
  end,
  },
})


