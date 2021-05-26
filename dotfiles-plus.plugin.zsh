# Dotfiles Plus Plugin for Oh My Zsh:
# GitHub: https://github.com/see-gee/dotfiles-plus

# Variables
DOTFILES_DIR=${DOTFILES_DIR:=$HOME/.dotfiles}
DOTFILES_URL=${DOTFILES_URL:="$(git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" remote get-url origin)"}

# Alias to call git with proper path options. 
# Using a git alias is preferred over full command line substitution.
# This checks for git alias called "dotfiles", and uses that if it exists
# if not, command substitution will be used. You can create the git alias
# by calling the _dotfiles_git_alias function.
if [[ $(git config --global --get alias.dotfiles) ]]; then
  alias _dotfiles_git="git dotfiles"
else
  alias _dotfiles_git="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
fi

# Autoload Functions can be found in the same folder as this file.
# Filenames begin with an underscore (_) and match the name of the 
# function they call. Using the function autoload feature of zsh helps
# reduce unnecessary system resource usage.
# autoload -Uz ${0:h}/_*

dotfiles() {
  if [[ -z "$@" ]] || [[ $1 = "help" ]] || [[ $1 = "--help" ]] || [[ $1 = "-h" ]]; then
    _dotfiles_help
  elif [[ $1 = "download" ]]; then
    _dotfiles_git pull --recurse-submodules -j8t
  elif [[ $1 = "upload" ]]; then    
    _dotfiles_git push
  elif [[ $1 = "commit" ]]; then
    _dotfiles_git_staged
    _dotfiles_git_commit
  elif [[ $1 = "submodule" ]]; then    
    _dotfiles_git_submodule
  elif [[ $1 = "setup" ]]; then
    _dotfiles_git_alias
    _dotfiles_ignore
    _dotfiles_git_config
    _dotfiles_ignore
  else
     _dotfiles_git "$@"    
  fi
}

