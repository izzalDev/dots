#!/bin/bash

function main {
  setup_sudo_askpass
  mkdir -p ~/Repositories ~/Obsidian\ Vault/
  install_rosetta
  setup_homebrew
  brew bundle --verbose
  postinstall
  postinstall_ghostty
  postinstall_starship
  setup_dock
  return 0
}

function postinstall_starship {
  info "Executing postinstall script for starship"
  local script='eval "$(starship init zsh)"'
  if ! cat ~/.zshrc | grep -q "$script"; then
    echo "$script" >> ~/.zshrc
  fi
}

function info {
  local BLUE='\033[0;34m'
  local NC='\033[0m'
  printf "${BLUE}==>${NC} ${@}\n" 
}

function success {
  local GREEN='\e[0;33m'
  local NC='\033[0m'
  printf "${GREEN}==>${NC} ${@}\n"
}

function install_rosetta2 {
  if /usr/bin/arch -x86_64 /bin/true 2>/dev/null; then
    info "Rosetta 2 is already installed. No action needed."
    exit 0
  fi

  info "Rosetta 2 is not installed. Installing now..."
  echo "A" | sudo -A softwareupdate --install-rosetta --agree-to-license
}

function postinstall_ghostty {
  if ! brew list --cask | grep -q "ghostty"; then
    return 0
  fi

  info "Executing postinstall script for ghostty..."

  local CONFIG_DIR="${HOME}/.config/ghostty"
  local CONFIG_FILE="${HOME}/.config/ghostty/config"
  mkdir -p "${CONFIG_DIR}"
  echo "macos-titlebar-style = hidden" > "${CONFIG_FILE}"
  echo "window-padding-x = 5" >> "${CONFIG_FILE}"
  echo "window-padding-y = 5" >> "${CONFIG_FILE}"
  echo "theme = light:Github-Light-Default,dark:Github-Dark-Default" >> "${CONFIG_FILE}"
}

function setup_sudo_askpass {
  local TMPFILE=$(mktemp)
  
  trap 'echo "Cleaning up credentials..."; rm -f "${TMPFILE}"; kill ${CAFFEINE_PID} 2>/dev/null || true' EXIT
  
  for i in {1..3}; do
    read -s -p "Password: " PASSWORD
    echo
    
    # Check if the password is correct by testing with sudo -v
    echo "${PASSWORD}" | sudo -S -v &>/dev/null
    if [[ $? -eq 0 ]]; then
      # Create the temporary script with the correct password
      printf "#!/bin/zsh\necho \"%s\"\n" "${PASSWORD}" > "${TMPFILE}"
      chmod +x "${TMPFILE}"
      export SUDO_ASKPASS="${TMPFILE}"
      return
    fi
    echo "Sorry, try again."
  done
  
  # If all attempts fail, exit the script
  echo "sudo: 3 incorrect password attempts"
  exit 1
}

function setup_homebrew {
  local BREW_SHELLENV="/opt/homebrew/bin/brew shellenv"
  local BREW_BIN="/opt/homebrew/bin/brew"
  if [[ ! -x "${BREW_BIN}" ]]; then
    NONINTERACTIVE=1 \
    /bin/zsh -c "$(curl -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    grep -Fxq "eval \"\$(${BREW_SHELLENV})\"" ~/.zprofile || \
      echo "eval \"\$(${BREW_SHELLENV})\"" | tee -a ~/.zprofile
    eval "$(${BREW_SHELLENV})"
    success "Homebrew installed and configured successfully."
  fi
}

function setup_dock {
  info "Removing all dock items..."
  defaults write com.apple.dock persistent-apps -array
  info "Enabling recent applications in Dock..."
  defaults write com.apple.dock show-recents -bool true
  info "Setting recent applications count..."
  defaults write com.apple.dock show-recent-count -int 10
  defaults write com.apple.finder CreateDesktop false
  killall Finder
}

function postinstall {
  local POSTINSTALL_SCRIPTS=$(find postinstall -type f)
  for script in $POSTINSTALL_SCRIPTS; do
    local SCRIPT_NAME="$(basename "$script")"
    if brew bundle list --all | grep -q "$SCRIPT_NAME"; then
      info "Executing postinstall script for $SCRIPT_NAME..."
      $script 
    fi
  done
}

main

