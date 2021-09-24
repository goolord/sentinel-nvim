---
-- Function to retrieve console output
--
function os.capture(cmd, raw)
  local f = assert(io.popen(table.concat(cmd, ' '), 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  return s
end

local function unlines(str)
    local lines = {}
    for s in str:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    return lines
end

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

local find_command = { "fd", "--type", "f", "--hidden", "--no-ignore", "-L" }

local function find()
    local buttons = {}
    for _, file in ipairs(unlines(os.capture(find_command, false))) do
        local btn = button(file)
        table.insert(buttons, btn)
    end
    return buttons
end

require'sentinel.common'.register_provider {
    layout = {
        { type = "group", val = find }
    },
    req = {
        name = 'files',
    },
    opts = {
        previewer = nil,
        sorter = nil,
    },
}
