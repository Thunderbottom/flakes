{pkgs, ...}: {
  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPlugins = with pkgs.vimPlugins; [telescope-ui-select-nvim];

      colorschemes.ayu = {
        enable = true;
        # mirage = true;
      };

      keymaps = [
        {
          key = "<c-p>";
          action = "<cmd>Telescope fd<cr>";
        }
      ];

      plugins = {
        lsp = {
          enable = true;
          onAttach = ''
            vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false }]]
          '';
          servers = {
            gopls.enable = true;
            nixd.enable = true;
          };
        };
        lualine = {
          enable = true;
          iconsEnabled = true;
        };
        telescope = {
          enable = true;
          enabledExtensions = ["ui-select"];
          extensionConfig.ui-select = {};
          extensions.frecency.enable = true;
        };

        comment-nvim.enable = true;
        treesitter.enable = true;
        gitsigns.enable = true;
        nix.enable = true;
        nvim-autopairs.enable = true;
        illuminate.enable = true;
      };

      # TODO: get rid of hacks
      highlight = {
        SignColumn.bg = "none";
        GitSignsAdd.bg = "none";
        GitSignsChange.bg = "none";
        GitSignsDelete.bg = "none";
        DiffAdd.bg = "none";
        DiffChange.bg = "none";
        DiffDelete.bg = "none";
      };

      options = {
        # colorcolumn = "80";
        # cursorline = true;
        number = true;
        numberwidth = 4;
        relativenumber = true;
        signcolumn = "number";
        synmaxcol = 1024;

        sidescrolloff = 8;
        scrolloff = 8;
        wrap = false;

        autoindent = true;
        smartindent = true;

        splitbelow = true;
        splitright = true;

        expandtab = true;
        shiftwidth = 4;
        showtabline = 4;
        softtabstop = 4;
        tabstop = 4;

        hlsearch = true;
        ignorecase = true;
        smartcase = true;

        timeout = true;
        timeoutlen = 500;
        updatetime = 300;
        ttimeoutlen = 10;

        backup = false;
        swapfile = false;

        clipboard = "unnamedplus";
        mouse = "a";

        showmode = false;
        pumheight = 10;
        background = "dark";
        # termguicolors = true;
      };
    };
  };
}
