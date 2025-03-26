#!/bin/bash

setup() {
  set -e
  caffeinate &

  TMPFILE=$(mktemp)
  trap 'echo "Cleaning up credentioals..."; rm -f "$TMPFILE"' EXIT
  
  for i in 1 2 3; do
    read -s -p "Password: " PASSWORD
    echo
    
    # Check if the password is correct by testing with sudo -v
    echo "$PASSWORD" | sudo -S -v &>/dev/null
    if [[ $? -eq 0 ]]; then
      # Create the temporary script with the correct password
      printf "#!/bin/bash\necho \"%s\"\n" "$PASSWORD" > "$TMPFILE"
      chmod +x "$TMPFILE"
      export SUDO_ASKPASS="$TMPFILE"
      return
    fi

    echo "Sorry, try again."
  done
  
  # If all attempts fail, exit the script
  echo "sudo: 3 incorrect password attempts"
  exit 1
}

setup_dock() {
  BLUE='\033[0;34m'  # ANSI code for blue text
  NC='\033[0m'       # Reset color

  echo -e "${BLUE}==>${NC} Removing all dock items..."
  defaults write com.apple.dock persistent-apps -array

  echo -e "${BLUE}==>${NC} Enabling recent applications in Dock..."
  defaults write com.apple.dock show-recents -bool true

  echo -e "${BLUE}==>${NC} Setting recent applications count..."
  defaults write com.apple.dock show-recent-count -int 10

  echo -e "${BLUE}==>${NC} Restarting Dock..."
  killall Dock
}

main(){
  setup
  setup_dock

  BREW_SHELLENV="/opt/homebrew/bin/brew shellenv"
  BREW_BIN="/opt/homebrew/bin/brew"

  # Check if Homebrew was installed
  if [ ! -x "$BREW_BIN" ]; then
    # Install Homebrew
    NONINTERACTIVE=1 \
    /bin/bash -c "$(curl -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to .zprofile if not already present
    grep -Fxq "eval \"\$($BREW_SHELLENV)\"" ~/.zprofile || \
      echo "eval \"\$($BREW_SHELLENV)\"" | tee -a ~/.zprofile

    # Evaluate Homebrew's shell environment
    eval "$($BREW_SHELLENV)"
    echo "Homebrew installed and configured successfully."
  fi

  # Run Brew bundle
  brew bundle --verbose
}

main
