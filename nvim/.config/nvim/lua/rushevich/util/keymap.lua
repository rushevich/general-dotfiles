local M = {}

function M.map(lhs, rhs, desc, opts)
    opts = opts or {}
    local mode = opts.mode or "n"

    if opts.leader then
        lhs = "<leader>" .. lhs
    end
    if opts.cmd then
        rhs = "<cmd>" .. rhs .. "<cr>"
    end

    local set_opts = vim.tbl_extend("force", { desc = desc }, opts)
    set_opts.mode = nil
    set_opts.leader = nil
    set_opts.cmd = nil

    vim.keymap.set(mode, lhs, rhs, set_opts)
end

return M
