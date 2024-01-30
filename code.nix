{ config, pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      ms-python.python
      ms-vscode.cpptools
      esbenp.prettier-vscode

      vscodevim.vim

      arrterian.nix-env-selector
      denoland.vscode-deno
      ms-vscode.cmake-tools

      llvm-vs-code-extensions.vscode-clangd


    #] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #{
        #name = "pink-as-fox";
        #publisher = "Avoonix";
        #version = "1.8.1";
        #sha256 = "SKUx26XIiPsxHxMbk/O/mQ267a3svFhgjvWpPXKSHjs=";
      #}
    ];
  };
}
