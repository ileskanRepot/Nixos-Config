{config, pkgs, ...}:
{
  imports = [
    ./secret.nix
    ./i3.nix
    ./bash.nix
    ./vim.nix
  ];
}
