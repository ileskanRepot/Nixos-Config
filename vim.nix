{config, pkgs, ...}:
{
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    extraConfig = ''
      set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
      nnoremap \ :set nu! rnu!<Return>
      set wildmenu
      set lazyredraw
      highlight LineNr ctermfg=13 ctermbg=0
      highlight Search ctermfg=0 ctermbg=13
      highlight NonText ctermfg=5
    '';
  };
}
