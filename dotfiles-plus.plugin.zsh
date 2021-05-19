# Dotfiles Plus Plugin for Oh My Zsh:
# GitHub: https://github.com/see-gee/dotfiles-plus

# Variables
DOTFILES_GIT_DIR=$DOTFILES_GIT_DIR:-$HOME/.dotfiles
DOTFILES_GIT_URL=""

# Functions
_dotfiles_git_staged() {
  local difflist=$(git dotfiles--no-pager diff --name-only)
  [[ ! -z ${difflist// } ]] && return 0 || return 1
}

_dotfiles_git_alias() {
  echo "Work In Progress"
  if [[ $(git config --global --get alias.dotfiles) ]]; then
    echo "Git alias for 'dotfiles' found"
    return 0
  else
    echo "Git Alias for 'dotfiles' was not found. Creating..."
    git config --global alias.dotfiles '!git --git-dir="$DOTFILES_DIR" --work-tree="$HOME"' 
  fi
}

_dotfiles_git_ignore() {
  _dotfiles_git_ignore_add() {
    echo "Adding a few good ideas to $HOME/.gitignore file"
    ignore_list=(
      ".ssh"          
    )
    echo "'# Added by dotfiles-plus plugin on '$(date)" >> $HOME/.gitignore
    for i in ${ignore_list}; do
      echo "Adding $i"
      echo "$i\n" >> $HOME/.gitignore    
    done
  }
  if [[ -f $HOME/.gitignore ]]; then
    echo "Existing .gitignore file found:"
    cat $HOME/.gitignore
    echo "Would you like to create a backup of your existing .gitignore file \nand add some sensibile sauce to it? (Y/n)"
    read -qs "ans?"
    if [[ $ans = y ]]; then    
      backup=$HOME/.gitignore.pre.dotfiles-plus
      \cp -fp $HOME/.gitignore $backup
      echo "$backup created"
      _dotfiles_git_ignore_add      
    else
      echo "Alright. I'll just ignore your .gitignore file then."
      return 0
    fi    
  else
    _dotfiles_git_ignore_add
  fi
}

_dotfiles_git_config() {
  echo "Configuring Git:"  
  threadcount:-$(getconf _NPROCESSORS_ONLN)# Get CPU thread count
  [[  $threadcount > 8 ]] && echo "$threadcount threads. Nice CPU ;)"; threadcount=8
  typeset -A git_config_opts=(
    status.showuntrackedfiles no
    submodule.recurse true
    submodule.fetchjobs $cpu_threads
  )  
  for key val in ${(@kv)git_config_opts}; do
    if [[ "$(git dotfiles config --get $key)" ]]; then
      echo "$key already set to [$val], no changes made"      
    else
      echo "Setting $key to [$val]"
      git dotfiles config $key $val
    fi    
  done  
}

_dotfiles_git_init() {
  if [[ ! -d $DOTFILES_DIR ]]; then
    mkdir $DOTFILES_DIR
    git  --git-dir="$DOTFILES_DIR" --work-tree="$HOME" init --bare
    _dotfiles_git_config
    return 0
  else
    echo "$DOTFILES_DIR directory already exists. 
    Move or delete to create a new repository"
    return 1
  fi
}

_dotfiles_help() {
  echo "Dotfiles Plus - Oh My Zsh Plugin\n
    The dotfiles command is a helper script to easily keep your dotfiles 
    organized and synchronized using a git repository.\n
  Usage:
    dotfiles <command> <options>\n  
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
  if [[ -z "$@" ]] || [[ $1 = "help" ]] || [[ $1 = "--help" ]] || [[ $1 = "-h" ]]
  then
    _dotfiles_help
  elif [[ $1 = "download" ]]; then
    git dotfiles pull --recurse-submodules -j8
  elif [[ $1 = "upload" ]]; then    
    git dotfiles push
  elif [[ $1 = "commit" ]]; then
    _dotfiles_git_staged
    _dotfiles_git_commit
  else
    git dotfiles "$@"    
  fi
}

