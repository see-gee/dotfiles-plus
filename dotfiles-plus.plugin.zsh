# Dotfiles Plus Plugin for Oh My Zsh:
# GitHub: https://github.com/see-gee/dotfiles-plus

# Variables
DOTFILES_GIT_DIR=${DOTFILES_GIT_DIR:=$HOME/.dotfiles}
DOTFILES_GIT_REPO=

# Alias to call git with proper path options. 
# Using a git alias is preferred over full command line substitution.
# This checks for git alias called "dotfiles", and uses that if it exists
# if not, command substitution will be used. You can create the git alias
# by calling the _dotfiles_git_alias function.
if [[ $(git config --global --get alias.dotfiles) ]]; then
  alias _dotfiles_git_cmd="git dotfiles"
else
  alias _dotfiles_git_cmd="git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME"
fi

# Autoload Functions can be found in the same folder as this file.
# Filenames begin with an underscore (_) and match the name of the 
# function they call. Using the autoload feature of zsh helps reduce 
# unnecessary system resource usage.
# autoload -Uz ${0:h}/_*

dotfiles() {
  if [[ -z "$@" ]] || [[ $1 = "help" ]] || [[ $1 = "--help" ]] || [[ $1 = "-h" ]]; then
    _dotfiles_help
  elif [[ $1 = "download" ]]; then
    _dotfiles_git_cmd pull --recurse-submodules -j8t
  elif [[ $1 = "upload" ]]; then    
    _dotfiles_git_cmd push
  elif [[ $1 = "commit" ]]; then
    _dotfiles_git_staged
    _dotfiles_git_commit
  elif [[ $1 = "submodule" ]]; then    
    _dotfiles_git_submodule
  elif [[ $1 = "setup" ]]; then
    _dotfiles_git_alias
    _dotfiles_git_config
    _dotfiles_git_ignore_add
  else
     _dotfiles_git_cmd "$@"    
  fi
}

