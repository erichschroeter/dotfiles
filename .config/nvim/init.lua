require("config.lazy")

vim.keymap.set('n', '<C-p>', function()
  require('fzf-lua').files()
end, { desc = 'FzfLua: Find files in current directory' })

