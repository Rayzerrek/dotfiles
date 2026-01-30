set fish_greeting

fish_add_path /c/Windows/system32
fish_add_path /c/Windows
fish_add_path /c/Program Files

set -gx STARSHIP_CONFIG ~/.config/starship.toml
starship init fish | source

set -gx EDITOR "nvim"
