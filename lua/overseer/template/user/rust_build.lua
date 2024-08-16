return {
    name = 'Build Rust',
    builder = function()
        local file = vim.fn.expand('%:p')
        return {
            cmd = "rustc",
            args = { file },
            -- default_component_params = {
            --     errorformat = set_efm(vim.bo.filetype),
            -- },
            components = {
                'default',
                'open_output',
                -- { 'on_output_quickfix', open = true },
            },
        }
    end,
    condition = {
        filetype = {"rust"},
    },
}
