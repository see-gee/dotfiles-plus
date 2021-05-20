# Dotfiles Plus Plugin for Oh My Zsh:
# GitHub: https://github.com/see-gee/dotfiles-plus

# Variables
DOTFILES_GIT_DIR=${DOTFILES_GIT_DIR:=$HOME/.dotfiles}
DOTFILES_GIT_REMOTE_URL=

# Functions
_dotfiles_git_staged() {
  local difflist=$(git dotfiles --no-pager diff --name-only)
  [[ ! -z ${difflist// } ]] && echo "$difflist"; return 0 || return 1
}

_dotfiles_git_commit() {
  _dotfiles_git_staged
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
    return $?
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
    echo "No .gitignore file found in $HOME.\nCreating .gitignore"
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
    git  --git-dir="$DOTFILES_DIR" --work-tree="$HOME" init --bare -b main
    _dotfiles_git_config
    return 0
  else
    echo "$DOTFILES_DIR directory already exists. 
    Move or delete to create a new repository"
    return 1
  fi
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

