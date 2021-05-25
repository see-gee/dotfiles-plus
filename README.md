# dotfiles-plus
Dotfiles Plus is a plungin for Oh My Zsh. The purpose is to create a simplified toolbox for creating, and managing a git repository (public, or private) for your configuration files. This allows you to esily migrate the files across all the machines you use, with the added benefit of proper version control.

# Usage:
The 'dotfiles' command accepts all standard git syntax, as well as a few "Helper" options that simplify some of the more advanced features git has to offer. Using 'dotfiles' at the command line ensures that you are __always__ working with your dotfiles repository, regardless of your current working directory. This is important to note, due to the nature of having a separate git directory and work tree on this repo. By default, your git directory will be called $HOME/.dotfiles. This can be overridden by setting the variable 'DOTFILES_GIT_DIR=<path_to_custom_git_dir>' in your '.zshrc' file.

dotfiles <git command> <git_options>
  -or-
dotfiles <dotfiles_command>




