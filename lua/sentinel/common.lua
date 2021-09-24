local M = {}

_G.sentinel = {}
_G.sentinel.providers = {}

function M.register_provider(opts)
    _G.sentinel.providers[opts.req.name] = opts
end

return M
