# Dotfiles Plus Plugin for Oh My Zsh:
# GitHub: https://github.com/see-gee/dotfiles-plus

# Variables
DOTFILES_DIR=$HOME/.dotfiles
DOTFILES_URL=""

# Functions
_dotfiles_staged_files() {
  local diffList=$(git dotfiles--no-pager diff --name-only)
  [ ! -z ${diffList// } ] && return
  false
}

_dotfiles_git_alias() {
  echo "Work In Progress"
  if [[ $(git config --global --get alias.dotfiles) ]]; then
    echo "Git alias for 'dotfiles' found"
    return 0
  else
    echo "Git Alias for 'dotfiles' was not found. Creating..."
    git config --global alias.dotfiles '!git --git-dir=$DOTFILES_DIR --work-tree=$HOME' 
  fi
}

_dotfiles_git_config() {
  cmd="git dotfiles config --local"
  typeset -A opts=(
    showUntrackedFiles "no"
    submodule.recurse "true"
    submodule.fetchjobs "8"
  )  
  
  for key val in ${(@kv)opts}; do
    if [[ $($cmd" --get "$key) ]]; then
      echo "Option [$key] already set"
      return 0
    else
      echo "Setting [$key] to $val"
      $cmd $key $val
    fi    
  done
}

_dotfiles_init_repo() {
  if [[ ! -d $DOTFILES_DIR ]]; then
    mkdir $DOTFILES_DIR
    git  --git-dir=$DOTFILES_DIR --work-tree=$HOME init --bare
    _dotfiles_git_config
  else
    echo "$DOTFILES_DIR directory already exists. 
    Move or delete to create a new repository"
  fi
}

_dotfiles_help() {
  echo "Dotfiles Plus - Oh My Zsh Plugin\n
    The dotfiles command is an easy way to keep your dotfiles organized and
    synchronized using a git repository.
  Usage:
    dotfiles <command> <options>
  
  Commands:
    add               Add a file to your dotfiles repo
    commit            Commit changes to dotfiles
    download, pull    Download from remote dotfiles repo
    upload, push      Upload changes to remote dotfiles repo
    status            Show current status of dotfiles repo
    submodule         Manipulate submodules within your repo.
    help              Show this help

  Options:
    --setup               Configure plugin for first time use. 
                          See README.md for details
    --check-settings      Verify your git settings for your dotfiles repo
                          are correct
  "
}

dotfiles() {
  if [[ -z "$@" ]] || [[ $1 = ("help" || "--help") ]]; then
    _dotfiles_help
  elif [[ $1 = "download" ]]; then
    git dotfiles pull --recurse-submodules -j8
  elif [[ $1 = "upload" ]]; then    
    git dotfiles push
  else
    git dotfiles "$@"    
  fi
}

