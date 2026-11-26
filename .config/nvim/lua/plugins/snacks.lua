-- svg buffer -> { win = preview window, png = last rendered file }
local svg_previews = {}

-- snacks caches conversions by path only, so render each save to a new png ourselves
local function render_svg(svg_buf)
  local p = svg_previews[svg_buf]
  if not (p and vim.api.nvim_win_is_valid(p.win)) then return end
  local src = vim.api.nvim_buf_get_name(svg_buf)
  local dir = vim.fn.stdpath("cache") .. "/svg-preview"
  vim.fn.mkdir(dir, "p")
  local png = ("%s/%s-%d.png"):format(dir, vim.fn.sha256(src):sub(1, 8), vim.uv.hrtime())
  vim.system({ "magick", "-background", "none", "-density", "192", src, png }, {}, vim.schedule_wrap(function(res)
    if res.code ~= 0 then
      vim.notify("SVG preview: " .. vim.trim(res.stderr), vim.log.levels.ERROR)
      return
    end
    if not vim.api.nvim_win_is_valid(p.win) then return os.remove(png) end
    local old = vim.api.nvim_win_get_buf(p.win)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(p.win, buf)
    Snacks.image.buf.attach(buf, { src = png })
    if vim.api.nvim_buf_is_valid(old) then vim.api.nvim_buf_delete(old, { force = true }) end
    if p.png then os.remove(p.png) end
    p.png = png
  end))
end

-- favicons hold several sizes in any order; show the largest one, scaled up with sharp pixels
local function open_ico(ev)
  local src = vim.api.nvim_buf_get_name(ev.buf)
  local sizes = vim.system({ "magick", "identify", "-format", "%[fx:w*h] ", src }):wait()
  if sizes.code ~= 0 then
    vim.notify("ICO: " .. vim.trim(sizes.stderr), vim.log.levels.ERROR)
    return
  end
  local best, frame = -1, 0
  for i, area in ipairs(vim.split(vim.trim(sizes.stdout), " ")) do
    if tonumber(area) > best then best, frame = tonumber(area), i - 1 end
  end
  local dir = vim.fn.stdpath("cache") .. "/ico-preview"
  vim.fn.mkdir(dir, "p")
  local png = ("%s/%s.png"):format(dir, vim.fn.sha256(src):sub(1, 8))
  vim.system({ "magick", ("%s[%d]"):format(src, frame), "-filter", "point", "-resize", "256x256<", png }):wait()
  Snacks.image.buf.attach(ev.buf, { src = png })
end

local function toggle_svg_preview()
  local svg_buf = vim.api.nvim_get_current_buf()
  local p = svg_previews[svg_buf]
  if p and vim.api.nvim_win_is_valid(p.win) then
    vim.api.nvim_win_close(p.win, true)
    if p.png then os.remove(p.png) end
    svg_previews[svg_buf] = nil
    return
  end
  local cur = vim.api.nvim_get_current_win()
  local win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, { split = "right", win = cur })
  svg_previews[svg_buf] = { win = win }
  render_svg(svg_buf)
end

return {
  "folke/snacks.nvim",
  lazy = false,
  init = function()
    -- inside tmux snacks detects kitty with a 1s terminal query that often times out
    if vim.env.KITTY_WINDOW_ID then
      vim.env.SNACKS_KITTY = "true"
    end
  end,
  opts = {
    image = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    local Placement = require("snacks.image.placement")
    local update = Placement.update
    local ns = vim.api.nvim_create_namespace("snacks.image")
    Placement.update = function(self)
      -- snacks bug (PR #2635): a hidden image is never un-hidden, so reopening its buffer renders blank
      if self.hidden and vim.api.nvim_buf_is_valid(self.buf) and #self:wins() > 0 then
        self.hidden = false
      end
      update(self)
      -- snacks bug: after converting an image (jpg, webp, ...) the last "loading" spinner frame is never removed
      if not (self:ready() and vim.api.nvim_buf_is_valid(self.buf)) then return end
      for _, m in ipairs(vim.api.nvim_buf_get_extmarks(self.buf, ns, 0, -1, { details = true })) do
        local vt = m[4].virt_text
        if vt and vt[1] and vt[1][2] == "SnacksImageSpinner" then
          vim.api.nvim_buf_del_extmark(self.buf, ns, m[1])
        end
      end
    end

    local group = vim.api.nvim_create_augroup("UserSvgPreview", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "svg",
      callback = function(ev)
        vim.keymap.set("n", "<leader>ip", toggle_svg_preview, { buffer = ev.buf, desc = "[I]mage [P]review (svg)" })
      end,
    })
    vim.api.nvim_create_autocmd("BufReadCmd", { group = group, pattern = "*.ico", callback = open_ico })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      pattern = "*.svg",
      callback = function(ev) render_svg(ev.buf) end,
    })
  end,
}
