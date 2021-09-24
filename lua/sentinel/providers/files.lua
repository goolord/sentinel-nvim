local common = require'sentinel.common'

local input = ''

local function button(filename)
    local opts = {
        position = "left",
        cursor = 1,
        -- width = 50,
        shrink_margin = false,
    }
    local function on_press ()
        local cmd = vim.api.nvim_replace_termcodes(':e ' .. filename .. '<CR>', true, false, true)
        vim.api.nvim_feedkeys(cmd, "normal", false)
    end

    return {
        type = "button",
        val = filename,
        on_press = on_press,
        opts = opts
    }
end

local find_command = { "fd", "--type", "f", "-L" }

local function find(search_str)
    local buttons = {}
    local find_query = {}
    vim.list_extend(find_query, find_command)
    vim.list_extend(find_query, {search_str})
    for _, file in ipairs(common.unlines(os.capture(find_query, false))) do
        local btn = button(file)
        table.insert(buttons, btn)
    end
    return buttons
end

require'sentinel.common'.register_provider {
    layout = {
        { type = "group", val = find(input) }
    },
    req = {
        name = 'files',
    },
    opts = {
        previewer = nil,
        sorter = nil,
    },
}
