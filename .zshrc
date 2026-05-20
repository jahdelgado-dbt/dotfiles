
# Added by dbt installer
export PATH="$PATH:/Users/jahdelgado/.local/bin"

# dbt aliases
alias dbtf=/Users/jahdelgado/.local/bin/dbt
export PATH="$HOME/.local/bin:$PATH"
alias dispatch="claude --plugin-dir ~/dispatch"


# ctOS prompt
autoload -U colors && colors
PROMPT='%F{cyan}[ctOS/%n]%f %F{blue}%~%f
%F{cyan}>_%f '
RPROMPT='%F{blue}%*%f'
