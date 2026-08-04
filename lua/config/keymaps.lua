-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-----------------
-- Insert mode --
-----------------

-- C 系语言（clangd 覆盖的文件类型）：
-- 在 { } 之间按 Enter 时，按 clang-format 风格换行：
--   int main() {}     -- 输入 { 后 autopairs 自动补全 }
--   按 Enter 得到:
--   int main() {
--       |<cursor>
--   }
local cfamily = { 'c', 'cpp', 'cuda', 'objc', 'objcpp' }

local function indent_for(cols)
    if vim.bo.expandtab then
        return string.rep(' ', cols)
    end
    local ts = vim.bo.tabstop
    return string.rep('\t', math.floor(cols / ts)) .. string.rep(' ', cols % ts)
end

local function split_brace_pair()
    -- 1-based col：光标处的字符
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    local before = col > 1 and line:sub(col - 1, col - 1) or ''
    local after = line:sub(col, col)
    -- 光标在 { 之后：后面是 autopairs 补的 }，或直接到行尾
    if before == '{' and (after == '}' or after == '') then
        local sw = vim.fn.shiftwidth()
        local base = vim.fn.indent('.')
        local head = line:sub(1, col - 2)
        local tail = line:sub(col + 1)
        local lnum = vim.fn.line('.')
        vim.api.nvim_set_current_line(head .. '{')
        if after == '}' then
            vim.api.nvim_buf_set_lines(0, lnum, lnum, false, {
                indent_for(base + sw),
                indent_for(base) .. '}' .. tail,
            })
        else
            vim.api.nvim_buf_set_lines(0, lnum, lnum, false, { indent_for(base + sw) })
        end
        vim.api.nvim_win_set_cursor(0, { lnum + 1, base + sw })
        -- 插入模式下光标列可能被钳制到缩进的最后一个字符上，
        -- 再按一次 End 确保光标落在缩进之后
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, false, true), 'n', false)
        return true
    end
    return false
end

local smart_cr = function()
    -- 光标在 { 之后按 Enter：直接按 formatter 风格拆行（处理 { 和 {} 两种形态）
    if split_brace_pair() then
        return
    end
    -- 其余情况：保持默认 Enter 行为（换行 + autoindent）
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = cfamily,
    callback = function()
        vim.keymap.set('i', '<CR>', smart_cr, {
            buffer = true,
            desc = 'Enter: split {} like clang-format',
        })
    end,
})
