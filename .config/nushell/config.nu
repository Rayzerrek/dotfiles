# config.nu
$env.config.show_banner = false
$env.config.highlight_resolved_externals = true

alias c = clear
alias gup = git push
alias vim = nvim
alias up = cd ../

$env.EDITOR = 'nvim'

use std/util "path add"

path add "~/.local/bin"
path add "~/.npm-global/bin"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")




