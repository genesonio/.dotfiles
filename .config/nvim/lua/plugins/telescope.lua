-- Find the git root of the current buffer (falls back to cwd)
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local current_dir = current_file == "" and cwd or vim.fn.fnamemodify(current_file, ":h")

  local git_root = vim.fn.systemlist({ "git", "-C", current_dir, "rev-parse", "--show-toplevel" })[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  require("telescope.builtin").live_grep({ search_dirs = { find_git_root() } })
end

-- Shorthand for "call this telescope.builtin picker"
local function builtin(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope", "LiveGrepGitRoot" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<leader>?", builtin("oldfiles"), desc = "[?] Find recently opened files" },
    { "<leader><space>", builtin("buffers"), desc = "[ ] Find existing buffers" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
    { "<leader>gf", builtin("git_files"), desc = "Search [G]it [F]iles" },
    { "<leader>sf", builtin("find_files"), desc = "[S]earch [F]iles" },
    { "<leader>sh", builtin("help_tags"), desc = "[S]earch [H]elp" },
    { "<leader>sw", builtin("grep_string"), desc = "[S]earch current [W]ord" },
    { "<leader>sg", builtin("live_grep"), desc = "[S]earch by [G]rep" },
    { "<leader>sG", live_grep_git_root, desc = "[S]earch by [G]rep on git root" },
    { "<leader>sd", builtin("diagnostics"), desc = "[S]earch [D]iagnostics" },
    { "<leader>sr", builtin("resume"), desc = "[S]earch [R]esume" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- wrap_results = true,
        -- path_display = {shorten = 4}
      },
    })
    pcall(require("telescope").load_extension, "fzf")
    vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})
  end,
}
