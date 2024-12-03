---@type ChadrcConfig
local M = {
    user = function()
    vim.opt.fileencodings = "ucs-bom,utf-8,gbk,big5,latin1"
    vim.opt.expandtab = true
    vim.bo.swapfile = false
    vim.opt.tabstop = 4
  end,
}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
