local M = {}

local ui = require('gamma-ui')
require('sentinel.common')
-- register providers
require('sentinel.providers.files')

function M.start(opts)
    local window = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(window, buffer)

    local state = {
        line = 0,
        buffer = buffer,
        window = window,
        win_width = 0,
        cursor_ix = 1,
        cursor_jumps = {},
        cursor_jumps_press = {},
    }
    ui.register_ui('sentinel', state)

    _G.gamma_ui.sentinel.enable(opts)
    _G.gamma_ui.sentinel.draw(opts)
    ui.keymaps(opts, state)
    -- ui.keymaps(opts, state)
end

function M.provider(name)
    M.start(_G.sentinel.providers[name])
end

function M.setup()
    vim.cmd[[
        command! -nargs=1 Sentinel call luaeval("require'sentinel'.provider(_A)", expand('<args>'))
    ]]
end

return M
