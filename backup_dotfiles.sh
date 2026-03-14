#!/bin/bash
# Script to backup current dotfiles to the repository

DOTFILES_LOCAL_REPO="$HOME/repositories/dotfiles"
DOTFILES_FILES=(
  ".zshrc"
  ".gitignore"
  ".gitconfig"
  ".githelpers"
  ".inputrc"
  ".macos"
  ".vimrc"
)

echo "Backing up dotfiles to $DOTFILES_LOCAL_REPO..."

# Create directory if it doesn't exist
mkdir -p "$DOTFILES_LOCAL_REPO"

for file in "${DOTFILES_FILES[@]}"; do
  if [ -f "$HOME/$file" ]; then
    echo "Copying $file..."
    cp "$HOME/$file" "$DOTFILES_LOCAL_REPO/"
  else
    echo "Skipping $file (not found in home directory)."
  fi
done

cd "$DOTFILES_LOCAL_REPO"
if [ -d ".git" ]; then
  git add .
  git commit -m "Update dotfiles from $(hostname) on $(date)"
  echo "Dotfiles backed up. Don't forget to 'git push'!"
else
  echo "Warning: $DOTFILES_LOCAL_REPO is not a git repository. Initialize it if you want to push to GitHub."
fi
