# https://repo.or.cz/llpp.git/blob_plain/04431d79a40dcc0215f87a2ad577f126a85c1e61:/help.ml
{ pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.tetex
      pkgs.zathura 
      pkgs.python39
      pkgs.texlive.combined.scheme-full # https://www.ejmastnak.com/tutorials/vim-latex/vimtex.html
    ];
}
