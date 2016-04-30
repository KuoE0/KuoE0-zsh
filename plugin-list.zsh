[ "$OS" = "linux" ] && zgen load zsh-users/zsh-autosuggestions # XXX crash if it enabled with zsh-syntax-highlight on OS X
zgen load KuoE0/oh-my-zsh-solarized-powerline-theme solarized-powerline.zsh-theme # Zsh theme
zgen oh-my-zsh plugins/autoenv
zgen oh-my-zsh plugins/bower
zgen oh-my-zsh plugins/brew
zgen oh-my-zsh plugins/brew-cask
zgen oh-my-zsh plugins/command-not-found
zgen oh-my-zsh plugins/copydir
zgen oh-my-zsh plugins/copyfile
zgen oh-my-zsh plugins/fasd
zgen oh-my-zsh plugins/gem
zgen oh-my-zsh plugins/git
zgen oh-my-zsh plugins/git-flow
zgen oh-my-zsh plugins/history
zgen oh-my-zsh plugins/history-substring-search
zgen oh-my-zsh plugins/mosh
zgen oh-my-zsh plugins/npm
zgen oh-my-zsh plugins/osx
zgen oh-my-zsh plugins/pip
zgen oh-my-zsh plugins/tmux
zgen oh-my-zsh plugins/urltools
zgen oh-my-zsh plugins/web-search
zgen load zsh-users/zsh-syntax-highlighting # zsh-syntax-highlight **MUST** be end!!!