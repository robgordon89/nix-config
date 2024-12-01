return {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local nvimtree = require("nvim-tree")

      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      nvimtree.setup({
        view = {
          width = 35,
          relativenumber = false,
        },
        filters = {
          custom = { ".DS_Store" },
        },
        git = {
            enable = true,
            ignore = true,
        },
        filesystem_watchers = {
            enable = true,
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
                resize_window = true,
            },
            remove_file = {
                close_window = true,
            },
            change_dir = {
                enable = true,
                global = true,
                restrict_above_cwd = true,
            },
        },

        renderer = {
            root_folder_label = true,
            highlight_git = true,
            highlight_opened_files = "none",
            special_files = { "Makefile", "README.md", "readme.md", "LICENSE", "Dockerfile" },

            indent_markers = {
                enable = true,
                icons = {
                    corner = "└",
                    edge = "│",
                    none = "",
                },
            },


            icons = {
                git_placement = "after",
                modified_placement = "after",
                show = {
                    file = false,
                    folder = false,
                    folder_arrow = true,
                    git = true,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        default = "/",
                        empty = "/",
                        empty_open = "/",
                        open = "/",
                        symlink = "/",
                        symlink_open = "/",
                    },
                    git = {
                        unstaged = "[U]",
                        staged = "[S]",
                        unmerged = "[ ]",
                        renamed = "[R]",
                        untracked = "[?]",
                        deleted = "[D]",
                        ignored = "[I]",
                    },
                },
            },
        },
      })

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
      keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
      keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
      keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
    end
}
