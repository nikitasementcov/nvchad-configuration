local map = vim.keymap.set

local M = {}

M.general = {

  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    -- Close buffer + hide terminal buffer
    ["<leader>q"] = {

      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },

    -- Save file
    ["<leader>w"] = { "<cmd>w<CR>", "Save file" },

    -- Diagnostic setloclist
    ["<leader>Q"] = {
      vim.diagnostic.setloclist,
      "Diagnostic setloclist",
    },

    -- LSP formatting

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,

      "LSP formatting",
    },

    -- Resize splits
    ["<C-w>h"] = { ":vertical resize -5<CR>", desc = "Resize window left" },
    ["<C-w>l"] = { ":vertical resize +5<CR>", desc = "Resize window right" },
    ["<C-w>k"] = { ":resize -5<CR>", desc = "Resize window up" },
    ["<C-w>j"] = { ":resize +5<CR>", desc = "Resize window down" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
  i = {
    ["jj"] = { "<ESC>" },
  },
}

M.neotest = {
  n = {

    ["<leader>tt"] = {
      function()
        require("neotest").run.run()
      end,
      "Run nearest test",
    },
    ["<leader>tf"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,

      "Run file test",
    },
    ["<leader>to"] = {
      ":Neotest output<CR>",
      "Test output",
    },
    ["<leader>ts"] = {
      ":Neotest summary<CR>",
      "Test summary",
    },
  },
}

-- Overwrite nvchad 'w' letter
M.lsp_workspace = {
  n = {

    ["<leader>Wa"] = {
      vim.lsp.buf.add_workspace_folder,
      "Add workspace folder",
    },

    ["<leader>Wr"] = {
      vim.lsp.buf.remove_workspace_folder,
      "Remove workspace folder",
    },
    ["<leader>Wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  },
}

M.which_key = {
  n = {

    ["<leader>WK"] = {

      "<cmd>WhichKey<CR>",
      "Which-key all keymaps",
    },
    ["<leader>Wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "

        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    ["<leader>o"] = { "<cmd>NvimTreeFocus<CR>", "Focus nvimtree" },
  },
}

local toggle_float = {

  function()
    require("nvterm.terminal").toggle "float"
  end,

  "Toggle floating term",
}

M.nvterm = {

  plugin = true,
  t = {

    ["<F7>"] = toggle_float,
    ["<C-\\>"] = {

      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<C-|>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,

      "Toggle vertical term",
    },
  },
  n = {

    ["<F7>"] = toggle_float,
    ["<C-\\>"] = {

      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<C-|>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,

      "Toggle vertical term",
    },
  },
}

-- Function to set mappings from the M table

local function set_mappings(mappings)
  for _, section in pairs(mappings) do
    -- Skip 'plugin' key if present
    if section.plugin then
      section.plugin = nil
    end
    for mode, mode_mappings in pairs(section) do
      for key, mapping_info in pairs(mode_mappings) do
        local opts = {}
        local rhs = nil

        if type(mapping_info) == "table" then
          rhs = mapping_info[1]
          opts.desc = mapping_info[2]

          if mapping_info.opts then
            opts = vim.tbl_extend("force", opts, mapping_info.opts)
          end
        else
          rhs = mapping_info
        end

        map(mode, key, rhs, opts)
      end
    end
  end
end

set_mappings(M)
