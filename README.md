# Rayzerrek's Dotfiles

Zcentralizowane repozytorium dotfiles dla systemów Windows.

## Zawartość
- `.agents/` - Konfiguracja agentów i umiejętności (`skills`)
- `nvim/` - Konfiguracja edytora Neovim (`init.lua`)
- `.vscode/` - Konfiguracja VS Code (`settings.json`, `keybindings.json`, `extensions.json`)

## Jak to działa?
Konfiguracje są przeniesione do tego folderu, a w ich oryginalnych miejscach utworzone są skróty symboliczne typu **Junction (Directory Junctions)** na Windowsie. Dzięki temu zmiany dokonane w aplikacjach są natychmiast widoczne w repozytorium dotfiles i odwrotnie.

## Przywracanie / Odtwarzanie konfiguracji na nowym komputerze:
Uruchom następujące polecenia w wierszu poleceń (cmd) jako zwykły użytkownik po sklonowaniu repozytorium do `C:\Users\kacpe\dotfiles`:

```cmd
:: Zlinkuj .agents
mklink /J C:\Users\kacpe\.agents C:\Users\kacpe\dotfiles\.agents

:: Zlinkuj Neovim
mklink /J C:\Users\kacpe\AppData\Local\nvim C:\Users\kacpe\dotfiles\nvim

:: Zlinkuj VS Code
mklink /J C:\Users\kacpe\AppData\Roaming\Code\User C:\Users\kacpe\dotfiles\.vscode
```
