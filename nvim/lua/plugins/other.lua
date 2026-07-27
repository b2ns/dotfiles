return {
  {
    -- https://github.com/crag666/code_runner.nvim
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    keys = {
      {
        "<leader>rr",
        function()
          vim.cmd("silent! wall")
          vim.cmd("RunCode")
        end,
        desc = "Save & Run Code",
      },
      {
        "<leader>rf",
        function()
          vim.cmd("silent! wall")
          vim.cmd("RunFile")
        end,
        desc = "Save & Run File",
      },
      {
        "<leader>rp",
        function()
          vim.cmd("silent! wall")
          vim.cmd("RunProject")
        end,
        desc = "Save & Run Project",
      },
      {
        "<leader>rc",
        "<cmd>RunClose<cr>",
        desc = "Close Run",
      },
    },
    opts = {
      mode = "term",
      term = {
        position = "vert belowright",
        size = 50,
      },
      filetype = {
        typescript = "tsx",
        typescriptreact = "tsx",
        go = "go run",
        rust = {
          "cd $dir &&",
          "rustc $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
        },
      },
      root_markers = {
        { "package.json", "npm start" }, -- js/ts/tsx projects
        { "go.mod", "go run ." },
        { "Cargo.toml", "cargo run" },
      },
    },
    config = function(_, opts)
      require("code_runner").setup(opts)
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function(args)
          vim.keymap.set("n", "q", "<cmd>RunClose<cr>", { buffer = args.buf, silent = true })
        end,
      })
    end,
  },
}
