# dotfiles-plus
Dotfiles Plus is a plugin for Oh My Zsh. The purpose is to create a simplified toolbox for creating, and managing a git repository (public, or private) for your configuration files. This allows you to esily migrate the files across all the machines you use, with the added benefit of proper version control. We use a bare repo approach which allows for version control with files in place. No messy copies, scripts, and symlinks. This also prevents git from thinking your entire home directory as a repo, but instead, __git only sees the files you add explicitly__. Another design feature is the use of submodules. By adding other repositories as submodules, you can simply pull all your related repos at the same time.

## Installation
To install Dotfiles-Plus plugin, run the following in the terminal:
  `git clone https://github.com/see-gee/dotfiles-plus.git $ZSH_CUSTOM/plugins/dotfiles-plus`

## Variables:
$DOTFILES_DIR defaults to $HOME/.dotfiles if not set



## Usage:
The 'dotfiles' command accepts all standard git syntax, as well as a few "Helper" options that simplify some of the more advanced features git has to offer. Using `dotfiles` at the command line ensures that you are __specifically__ working with your dotfiles repository, regardless of your current working directory. This is important to note, due to the nature of having a separate git directory and work tree on this repo. By default, your git directory will be $HOME/.dotfiles. This can be overridden by setting the variable `DOTFILES_DIR=<path_to_custom_git_dir>` in your `.zshrc` file.

`dotfiles <git command> <git_options>`
  -or-
`dotfiles <dotfiles_command>`

## Setup

Requirements:
- zsh
- 



