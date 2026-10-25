{ config, lib, pkgs, ... }:

{

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

  environment.systemPackages = with pkgs; [
    nodejs
    bun
    python3
    gcc
    zig
    uv
    neovim
    gh

  ];

  programs.git.enable = true;
  users.users.nixos.shell = pkgs.nushell;
  programs.nix-ld.enable = true;

}
