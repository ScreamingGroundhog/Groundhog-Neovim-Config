return {
    cmd = { "coq-lsp" },
    filetypes = { "coq" },
    root_dir = vim.fs.root(0, { "_CoqProject", ".git" }),
    single_file_support = true,
}
