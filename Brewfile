tap 'koekeishiya/formulae'
tap 'FelixKratz/formulae'

brew 'git'
brew 'nvim'
brew 'gh'
brew 'yabai'
brew 'fswatch'
brew 'jq'
brew 'bat'
brew 'btop'
brew 'lazygit'
brew 'lazydocker'
brew 'yazi'
brew 'sleepwatcher', 
  postinstall:"cp sleepwatcher/wakeup ~/.wakeup",
  start_service: true
brew 'colima', start_service: true
brew 'docker'
brew 'sketchybar', 
  postinstall:"cp -R sketchybar/ ~/.config/sketchybar/",
  start_service: true
brew 'bitwarden-cli'
brew 'duti'
brew 'koekeishiya/formulae/skhd'

cask_args no_quarantine: true
cask 'ghostty'
cask 'microsoft-word'
cask 'microsoft-excel'
cask 'microsoft-powerpoint'
cask 'arc'
cask 'obsidian'
cask 'displaperture'
cask 'font-sf-mono-nerd-font-ligaturized'
cask 'font-sf-pro'
cask 'google-drive'
cask 'iina'
cask 'the-unarchiver'
cask 'miniconda',
  postinstall: '/opt/homebrew/bin/conda init "$(basename "${SHELL}")"'

mas "Bitwarden", id: 1352778147
mas "Xcode", id: 497799835
