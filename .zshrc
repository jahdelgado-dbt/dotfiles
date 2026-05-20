
# Added by dbt installer
export PATH="$PATH:/Users/jahdelgado/.local/bin"

# dbt aliases
alias dbtf=/Users/jahdelgado/.local/bin/dbt
export PATH="$HOME/.local/bin:$PATH"
alias dispatch="claude --plugin-dir ~/dispatch"


# Pip-Boy 3000 phosphor prompt
autoload -U colors && colors
PROMPT='%F{green}[ROBCO/%n] %~%f
%F{green}>%f '
RPROMPT='%F{green}%*%f'
