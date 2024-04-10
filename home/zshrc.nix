{ maim, redshift, xclip, ... }: ''
  # The following lines were added by compinstall
  
  zstyle ':completion:*' auto-description 'specify: %d'
  zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
  zstyle ':completion:*' expand prefix suffix
  zstyle ':completion:*' ignore-parents parent
  zstyle ':completion:*' insert-unambiguous true
  zstyle ':completion:*' list-colors ""
  zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
  zstyle ':completion:*' list-suffixes true
  zstyle ':completion:*' matcher-list "" 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=** l:|=*'
  zstyle ':completion:*' menu select=1
  zstyle ':completion:*' original true
  zstyle ':completion:*' preserve-prefix '//[^/]##/'
  zstyle ':completion:*' verbose true
  zstyle :compinstall filename '/home/fabian/.zshrc'
  
  autoload -Uz compinit
  compinit
  # End of lines added by compinstall
  # Lines configured by zsh-newuser-install
  HISTFILE=~/.histfile
  HISTSIZE=1000
  SAVEHIST=1000
  setopt autocd extendedglob nomatch
  unsetopt beep notify
  bindkey -v
  # End of lines configured by zsh-newuser-install
  
  # Prompt
  setopt prompt_subst
  autoload -Uz vcs_info
  precmd_vcs_info() { vcs_info }
  precmd_functions+=( precmd_vcs_info )
  
  zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla cvs svn
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git+set-message:*' hooks format_msg
  
  function +vi-format_msg {
  local branch=$(git branch --show-current)
  
  if [[ -z "$branch" ]] ; then
  	branch=$(git rev-parse --short HEAD)
  fi
  
  local color=""
  
  if [[ -z $(git status --porcelain 2>/dev/null) ]];
  then
  	color="%F{blue}"
  fi
  
  if [[ $(git status --porcelain 2>/dev/null | grep "^A \|^M " | wc -l) > 0 ]];
  	then
  	color="%F{green}"
  fi
  
  if [[ $(git status --porcelain 2>/dev/null | grep "^??\|^AM\|^.D" | wc -l) > 0 ]] 
  then
  	color="%F{red}"
  fi
  
  ret=1
  hook_com[message]="$color($branch)%f "
  
  return 0
  }
  
  PROMPT='%B[%~] ''${vcs_info_msg_0_}%b'
  
  # Aliases and binds
  alias ls='ls --color -F'
  alias l='ls --color -FhAltr'
  alias x='killall --ignore-case --user=$(whoami) --interactive'
  alias sc='${maim}/bin/maim -s -u | ${xclip}/bin/xclip -selection clipboard -t image/png -i'
  alias tree='tree -CF'
  alias lock="betterlockscreen -l"
  alias nightmode="${redshift}/bin/redshift -P -O 1000"
  alias lightmode="${redshift}/bin/redshift -P -O 6500"
  alias inbox="echo >> $HOME/gtd/inbox"
  alias nixoide="nix repl '<nixpkgs>'"
  bindkey -e 
  bindkey ";5D" backward-word
  bindkey ";5C" forward-word
  bindkey "\e[3~" delete-char

  function use() {
    local pkg
    pkg="$1"
    shift
    nix shell "nixpkgs#$pkg" "$@"
  }

  function unuse() {
    local pkg
    pkg="$1"
    shift
    nix shell "unstable#$pkg" "$@"
  }

  function spawn () {
    if [ ! -x "$(command -v $1)" ]
      then
         echo "spawn: no such program: $1" >&2
         return 1
     fi
     $@ > /dev/null 0>&1 2>&1 &
     disown
  }

  autoload -Uz up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  autoload -Uz down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey '\eOA' up-line-or-beginning-search
  bindkey '\e[A' up-line-or-beginning-search
  bindkey '\eOB' down-line-or-beginning-search
  bindkey '\e[B' down-line-or-beginning-search
  
  # Env
  export TERM=xterm-256color
  export EDITOR=nvim
  export VISUAL=nvim
  export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
  export NIXPKGS_ALLOW_UNFREE=1
''
