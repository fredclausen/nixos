# Neovim Keymaps (dumped)

## Multiple / inferred modes

| Key                           | Action                                  | Description                         |
| ----------------------------- | --------------------------------------- | ----------------------------------- |
| `<Leader>-`                   | ``                                      | Toggle Snacks Explorer              |
| `<Leader>bn`                  | `<Cmd>bnext<CR>`                        | Next buffer                         |
| `<Leader>bp`                  | `<Cmd>bprevious<CR>`                    | Previous buffer                     |
| `<Leader>cu`                  | `<Cmd>Crates update_crate<CR>`          | Update crate on current line        |
| `<Leader>fb`                  | `<Cmd>Telescope buffers<CR>`            | Find buffers                        |
| `<Leader>ff`                  | `<Cmd>Telescope find_files<CR>`         | Find files                          |
| `<Leader>fg`                  | `<Cmd>Telescope live_grep<CR>`          | Live grep                           |
| `<Leader>fh`                  | `<Cmd>Telescope help_tags<CR>`          | Help tags                           |
| `<Leader>li`                  | `<Cmd>LspInfo<CR>`                      | LSP Info                            |
| `<Leader>rn`                  | ``                                      | Incremental Rename                  |
| `<Leader>uc`                  | `<Cmd>Crates update_all_crates<CR>`     | Update all crates                   |
| `<Leader>zz`                  | ``                                      | Open LazyGit                        |
| `<Plug>luasnip-expand-repeat` | ``                                      | LuaSnip: Repeat last node expansion |
| `gd`                          | `<Cmd>lua vim.lsp.buf.definition()<CR>` | Go to definition                    |
| `gr`                          | `<Cmd>lua vim.lsp.buf.references()<CR>` | Find references                     |

## Normal

| Key                                  | Action                                                                       | Description                                    |
| ------------------------------------ | ---------------------------------------------------------------------------- | ---------------------------------------------- |
| ``                                   | ``                                                                           | Switch Buffer                                  |
| `<Leader>/`                          | ``                                                                           | Live Grep                                      |
| `<Leader>gc`                         | ``                                                                           | Git Commits                                    |
| `<Leader>gs`                         | ``                                                                           | Git Status                                     |
| `<Leader>s"`                         | ``                                                                           | Registers                                      |
| `<Leader>sD`                         | ``                                                                           | Workspace Diagnostics                          |
| `<Leader>sb`                         | ``                                                                           | Search Current Buffer                          |
| `<Leader>sd`                         | ``                                                                           | Document Diagnostics                           |
| `<Leader>sh`                         | ``                                                                           | Help Pages                                     |
| `<Leader>sk`                         | ``                                                                           | Key Maps                                       |
| `%`                                  | `<Plug>(MatchitNormalForward)`                                               |                                                |
| `&`                                  | `:&&<CR>`                                                                    | :help &-default                                |
| `<C-L>`                              | `<Cmd>nohlsearch\|diffupdate\|normal! <C-L><CR>`                             | :help CTRL-L-default                           |
| `<C-W><C-D>`                         | `<C-W>d`                                                                     | Show diagnostics under the cursor              |
| `<C-W>d`                             | ``                                                                           | Show diagnostics under the cursor              |
| `<Plug>(MatchitNormalBackward)`      | `":<C-U>call matchit#Match_wrapper(''`                                       |                                                |
| `<Plug>(MatchitNormalForward)`       | `":<C-U>call matchit#Match_wrapper(''`                                       |                                                |
| `<Plug>(MatchitNormalMultiBackward)` | `':<C-U>call matchit#MultiMatch("bW"`                                        |                                                |
| `<Plug>(MatchitNormalMultiForward)`  | `':<C-U>call matchit#MultiMatch("W"`                                         |                                                |
| `<Plug>(fzf-insert)`                 | `i`                                                                          |                                                |
| `<Plug>(fzf-normal)`                 | ``                                                                           |                                                |
| `<Plug>(git-conflict-both)`          | `<Cmd>GitConflictChooseBoth<CR>`                                             | Git Conflict: Choose Both                      |
| `<Plug>(git-conflict-next-conflict)` | `<Cmd>GitConflictNextConflict<CR>`                                           | Git Conflict: Next Conflict                    |
| `<Plug>(git-conflict-none)`          | `<Cmd>GitConflictChooseNone<CR>`                                             | Git Conflict: Choose None                      |
| `<Plug>(git-conflict-ours)`          | `<Cmd>GitConflictChooseOurs<CR>`                                             | Git Conflict: Choose Ours                      |
| `<Plug>(git-conflict-prev-conflict)` | `<Cmd>GitConflictPrevConflict<CR>`                                           | Git Conflict: Previous Conflict                |
| `<Plug>(git-conflict-theirs)`        | `<Cmd>GitConflictChooseTheirs<CR>`                                           | Git Conflict: Choose Theirs                    |
| `<Plug>PlenaryTestFile`              | `:lua require('plenary.test_harness').test_file(vim.fn.expand(\"%:p\"))<CR>` |                                                |
| `<Plug>fugitive:`                    | ``                                                                           |                                                |
| `<Plug>fugitive:y<C-G>`              | `":<C-U>call setreg(v:register`                                              |                                                |
| `<Plug>luasnip-delete-check`         | ``                                                                           | LuaSnip: Removes current snippet from jumplist |
| `Y`                                  | `y$`                                                                         | :help Y-default                                |

<!-- markdownlint-disable -->

| `[ ` | `` | Add empty line above cursor |

<!-- markdownlint-enable -->

| `[%` | `<Plug>(MatchitNormalMultiBackward)` | |
| `[<C-L>` | ``| :lpfile |
| `[<C-Q>` |`` | :cpfile |
| `[<C-T>` | ``|  :ptprevious |
| `[A` |`` | :rewind |
| `[B` | ``| :brewind |
| `[D` |`` | Jump to the first diagnostic in the current buffer |
| `[L` | ``| :lrewind |
| `[Q` |`` | :crewind |
| `[T` | ``| :trewind |
| `[a` |`` | :previous |
| `[b` | ``| :bprevious |
| `[d` |`` | Jump to the previous diagnostic in the current buffer |
| `[l` | ``| :lprevious |
| `[q` |`` | :cprevious |
| `[t` | `` | :tprevious |

<!-- markdownlint-disable -->

| `] ` | `` | Add empty line below cursor |

<!-- markdownlint-enable -->

| `]%` | `<Plug>(MatchitNormalMultiForward)` | |
| `]<C-L>` | ``| :lnfile |
| `]<C-Q>` |`` | :cnfile |
| `]<C-T>` | ``| :ptnext |
| `]A` |`` | :last |
| `]B` | ``| :blast |
| `]D` |`` | Jump to the last diagnostic in the current buffer |
| `]L` | ``| :llast |
| `]Q` |`` | :clast |
| `]T` | ``| :tlast |
| `]a` |`` | :next |
| `]b` | ``| :bnext |
| `]d` |`` | Jump to the next diagnostic in the current buffer |
| `]l` | ``| :lnext |
| `]q` |`` | :cnext |
| `]t` | ``| :tnext |
| `g%` | `<Plug>(MatchitNormalBackward)` |  |
| `gO` |`` | vim.lsp.buf.document_symbol() |
| `gc` | ``| Toggle comment |
| `gcc` |`` | Toggle comment line |
| `gra` | ``| vim.lsp.buf.code_action() |
| `gri` |`` | vim.lsp.buf.implementation() |
| `grn` | ``| vim.lsp.buf.rename() |
| `grr` |`` | vim.lsp.buf.references() |
| `grt` | `` | vim.lsp.buf.type_definition() |

<!-- markdownlint-disable -->

| `gx` | `` | "Opens filepath or URI under cursor with the system handler (file explorer |

<!-- markdownlint-enable -->

| `y<C-G>` | `":<C-U>call setreg(v:register` | |
