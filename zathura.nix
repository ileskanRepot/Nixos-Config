{ config, pkgs, ...}:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      # set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
      # set langremap
      map e scroll up
      map n scroll down
      map h scroll left
      map i scroll right
    '';
  };
}
