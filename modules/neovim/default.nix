{ lib, config, pkgs, ... }:
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    viAlias = true;
    vimAlias = true;

    configure.customRC = ''
      set number
      set hidden
      set mouse=a

      set tabstop=4 shiftwidth=4 noexpandtab
      set listchars=tab:»\
      highlight Whitespace ctermfg=grey
      set list

      set undofile undodir=~/.config/nvim/tmp/undo//
    '';
  };
}
