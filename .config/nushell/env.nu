

# pnpm
$env.PNPM_HOME = "/home/nixos/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PNPM_HOME | path join "bin") )
# pnpm end
