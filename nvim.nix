# https://www.dannyadam.com/blog/2019/05/debugging-in-vim/
{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
      set langremap
      nnoremap \ :set nu! rnu!<Return>
      nnoremap co :VimtexCompile<Return>
      nnoremap <c-Semicolon> :VimtexView<Return>
      nnoremap <F5> :%!xxd<Return>
      nnoremap <F6> :%!xxd -r<Return>
      nnoremap = u\begin{align*}<Return><Return>\end{align*}<Up>
      highlight LineNr ctermfg=13 ctermbg=0
      highlight Search ctermfg=0 ctermbg=13
      highlight NonText ctermfg=5
      set hlsearch
      set tabstop=2
      set shiftwidth=2
      filetype plugin on
      filetype plugin indent on

      let g:python_recommended_style = 0
      let g:vimtex_view_general_viewer = 'zathura'      

      autocmd filetype tex highlight MatchParen ctermbg=8
      autocmd filetype tex set tw=80
      autocmd filetype txt set tw=80
      autocmd filetype tex set colorcolumn=80
      let mapleader = ","
      let g:vimspector_enable_mappings = 'HUMAN'

      set mouse=
    '';
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vimtex
      vimspector
    ];
  };
}
