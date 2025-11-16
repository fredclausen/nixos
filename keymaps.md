# Keymaps

| Key                                  | Action                                                                       | Description                                                                 |
| ------------------------------------ | ---------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------ | ---------------------- |
| ` cu`                                | `<Cmd>Crates update_crate<CR>`                                               | `Update crate on current line`                                              |
| ` uc`                                | `<Cmd>Crates update_all_crates<CR>`                                          | `Update all crates`                                                         |
| ` rn`                                | ``                                                                           | `Incremental Rename`                                                        |
| ` -`                                 | ``                                                                           | `Toggle Snacks Explorer`                                                    |
| ` zz`                                | ``                                                                           | `Open LazyGit`                                                              |
| ` fh`                                | `<Cmd>Telescope help_tags<CR>`                                               | `Help tags`                                                                 |
| ` fb`                                | `<Cmd>Telescope buffers<CR>`                                                 | `Find buffers`                                                              |
| ` fg`                                | `<Cmd>Telescope live_grep<CR>`                                               | `Live grep`                                                                 |
| ` ff`                                | `<Cmd>Telescope find_files<CR>`                                              | `Find files`                                                                |
| ` li`                                | `<Cmd>LspInfo<CR>`                                                           | `LSP Info`                                                                  |
| ` bp`                                | `<Cmd>bprevious<CR>`                                                         | `Previous buffer`                                                           |
| ` bn`                                | `<Cmd>bnext<CR>`                                                             | `Next buffer`                                                               |
| ` sk`                                | ``                                                                           | `Key Maps`                                                                  |
| ` sh`                                | ``                                                                           | `Help Pages`                                                                |
| ` sd`                                | ``                                                                           | `Document Diagnostics`                                                      |
| ` sb`                                | ``                                                                           | `Search Current Buffer`                                                     |
| ` sD`                                | ``                                                                           | `Workspace Diagnostics`                                                     |
| ` s`                                 | ``                                                                           | `Registers`                                                                 |
| ` gs`                                | ``                                                                           | `Git Status`                                                                |
| ` gc`                                | ``                                                                           | `Git Commits`                                                               |
| ` /`                                 | ``                                                                           | `Live Grep`                                                                 |
| ``                                   | ``                                                                           | `Switch Buffer`                                                             |
| `%`                                  | `<Plug>(MatchitNormalForward)`                                               | ``                                                                          |
| `&`                                  | `:&&<CR>`                                                                    | `:help &-default`                                                           |
| `Y`                                  | `y$`                                                                         | `:help Y-default`                                                           |
| `[%`                                 | `<Plug>(MatchitNormalMultiBackward)`                                         | ``                                                                          |
| `[ `                                 | ``                                                                           | `Add empty line above cursor`                                               |
| `[B`                                 | ``                                                                           | `:brewind`                                                                  |
| `[b`                                 | ``                                                                           | `:bprevious`                                                                |
| `[<C-T>`                             | ``                                                                           | ` :ptprevious`                                                              |
| `[T`                                 | ``                                                                           | `:trewind`                                                                  |
| `[t`                                 | ``                                                                           | `:tprevious`                                                                |
| `[A`                                 | ``                                                                           | `:rewind`                                                                   |
| `[a`                                 | ``                                                                           | `:previous`                                                                 |
| `[<C-L>`                             | ``                                                                           | `:lpfile`                                                                   |
| `[L`                                 | ``                                                                           | `:lrewind`                                                                  |
| `[l`                                 | ``                                                                           | `:lprevious`                                                                |
| `[<C-Q>`                             | ``                                                                           | `:cpfile`                                                                   |
| `[Q`                                 | ``                                                                           | `:crewind`                                                                  |
| `[q`                                 | ``                                                                           | `:cprevious`                                                                |
| `[D`                                 | ``                                                                           | `Jump to the first diagnostic in the current buffer`                        |
| `[d`                                 | ``                                                                           | `Jump to the previous diagnostic in the current buffer`                     |
| `]%`                                 | `<Plug>(MatchitNormalMultiForward)`                                          | ``                                                                          |
| `] `                                 | ``                                                                           | `Add empty line below cursor`                                               |
| `]B`                                 | ``                                                                           | `:blast`                                                                    |
| `]b`                                 | ``                                                                           | `:bnext`                                                                    |
| `]<C-T>`                             | ``                                                                           | `:ptnext`                                                                   |
| `]T`                                 | ``                                                                           | `:tlast`                                                                    |
| `]t`                                 | ``                                                                           | `:tnext`                                                                    |
| `]A`                                 | ``                                                                           | `:last`                                                                     |
| `]a`                                 | ``                                                                           | `:next`                                                                     |
| `]<C-L>`                             | ``                                                                           | `:lnfile`                                                                   |
| `]L`                                 | ``                                                                           | `:llast`                                                                    |
| `]l`                                 | ``                                                                           | `:lnext`                                                                    |
| `]<C-Q>`                             | ``                                                                           | `:cnfile`                                                                   |
| `]Q`                                 | ``                                                                           | `:clast`                                                                    |
| `]q`                                 | ``                                                                           | `:cnext`                                                                    |
| `]D`                                 | ``                                                                           | `Jump to the last diagnostic in the current buffer`                         |
| `]d`                                 | ``                                                                           | `Jump to the next diagnostic in the current buffer`                         |
| `g%`                                 | `<Plug>(MatchitNormalBackward)`                                              | ``                                                                          |
| `gr`                                 | `<Cmd>lua vim.lsp.buf.references()<CR>`                                      | `Find references`                                                           |
| `gd`                                 | `<Cmd>lua vim.lsp.buf.definition()<CR>`                                      | `Go to definition`                                                          |
| `gO`                                 | ``                                                                           | `vim.lsp.buf.document_symbol()`                                             |
| `grt`                                | ``                                                                           | `vim.lsp.buf.type_definition()`                                             |
| `gri`                                | ``                                                                           | `vim.lsp.buf.implementation()`                                              |
| `grr`                                | ``                                                                           | `vim.lsp.buf.references()`                                                  |
| `gra`                                | ``                                                                           | `vim.lsp.buf.code_action()`                                                 |
| `grn`                                | ``                                                                           | `vim.lsp.buf.rename()`                                                      |
| `gcc`                                | ``                                                                           | `Toggle comment line`                                                       |
| `gc`                                 | ``                                                                           | `Toggle comment`                                                            |
| `gx`                                 | ``                                                                           | `Opens filepath or URI under cursor with the system handler (file explorer` |
| `y<C-G>`                             | `:<C-U>call setreg(v:register`                                               | ``                                                                          |
| `<Plug>fugitive:`                    | ``                                                                           | ``                                                                          |
| `<Plug>fugitive:y<C-G>`              | `:<C-U>call setreg(v:register`                                               | ``                                                                          |
| `<Plug>PlenaryTestFile`              | `:lua require('plenary.test_harness').test_file(vim.fn.expand(\"%:p\"))<CR>` | ``                                                                          |
| `<Plug>luasnip-expand-repeat`        | ``                                                                           | `LuaSnip: Repeat last node expansion`                                       |
| `<Plug>luasnip-delete-check`         | ``                                                                           | `LuaSnip: Removes current snippet from jumplist`                            |
| `<Plug>(MatchitNormalMultiForward)`  | `:<C-U>call matchit#MultiMatch("W`                                           | ``                                                                          |
| `<Plug>(MatchitNormalMultiBackward)` | `:<C-U>call matchit#MultiMatch("bW`                                          | ``                                                                          |
| `<Plug>(MatchitNormalBackward)`      | `:<C-U>call matchit#Match_wrapper(`                                          | ``                                                                          |
| `<Plug>(MatchitNormalForward)`       | `:<C-U>call matchit#Match_wrapper(`                                          | ``                                                                          |
| `<Plug>(fzf-normal)`                 | ``                                                                           | ``                                                                          |
| `<Plug>(fzf-insert)`                 | `i`                                                                          | ``                                                                          |
| `<Plug>(git-conflict-prev-conflict)` | `<Cmd>GitConflictPrevConflict<CR>`                                           | `Git Conflict: Previous Conflict`                                           |
| `<Plug>(git-conflict-next-conflict)` | `<Cmd>GitConflictNextConflict<CR>`                                           | `Git Conflict: Next Conflict`                                               |
| `<Plug>(git-conflict-theirs)`        | `<Cmd>GitConflictChooseTheirs<CR>`                                           | `Git Conflict: Choose Theirs`                                               |
| `<Plug>(git-conflict-none)`          | `<Cmd>GitConflictChooseNone<CR>`                                             | `Git Conflict: Choose None`                                                 |
| `<Plug>(git-conflict-both)`          | `<Cmd>GitConflictChooseBoth<CR>`                                             | `Git Conflict: Choose Both`                                                 |
| `<Plug>(git-conflict-ours)`          | `<Cmd>GitConflictChooseOurs<CR>`                                             | `Git Conflict: Choose Ours`                                                 |
| `<C-W><C-D>`                         | `<C-W>d`                                                                     | `Show diagnostics under the cursor`                                         |
| `<C-W>d`                             | ``                                                                           | `Show diagnostics under the cursor`                                         |
| `<C-L>`                              | `<Cmd>nohlsearch                                                             | diffupdate                                                                  | normal! <C-L><CR>` | `:help CTRL-L-default` |
