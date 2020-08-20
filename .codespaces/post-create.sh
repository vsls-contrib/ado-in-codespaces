# add oh-my-bash
wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O - | sh -C

# connect AzDO npm feeds
echo "
; begin auth token
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/registry/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/registry/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/registry/:email=npm requires email to be set but doesn't use the value
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/VS/npm/:email=npm requires email to be set but doesn't use the value
; end auth token

; begin auth token
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/registry/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/registry/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/registry/:email=npm requires email to be set but doesn't use the value
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/NodeRepos/npm/:email=npm requires email to be set but doesn't use the value
; end auth token

; begin auth token
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/registry/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/registry/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/registry/:email=npm requires email to be set but doesn't use the value
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/:username=devdiv
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/_packaging/Cascade/npm/:email=npm requires email to be set but doesn't use the value
; end auth token

; begin auth token
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/registry/:username=devdiv
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/registry/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/registry/:email=npm requires email to be set but doesn't use the value
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/:username=devdiv
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/:_password=\${AZ_DO_PAT_BASE64}
//devdiv.pkgs.visualstudio.com/DevDiv/_packaging/playwright/npm/:email=npm requires email to be set but doesn't use the value
; end auth token
" >> ~/.npmrc

BASH_RC_FILE=~/.bashrc

PRE_OMB_BASH_CONFIG=~/.bashrc.pre-oh-my-bash
if [ -f $PRE_OMB_BASH_CONFIG ]; then
  cat $PRE_OMB_BASH_CONFIG >> $BASH_RC_FILE
  rm $PRE_OMB_BASH_CONFIG
fi

# add .bashrc config
echo "
## Color variables

# Dimmed text
export PALETTE_DIM='\e[2m'

# Bold Text
export PALETTE_BOLD='\e[1m'

# Underlined Text
export PALETTE_UNDERLINED='\e[4m'

# Blinking
export PALETTE_BLINK='\e[5m'

# Reverse
export PALETTE_REVERSE='\e[7m'

# Foreground Color
export PALETTE_BLACK='\e[30m'
export PALETTE_WHITE='\e[97m'
export PALETTE_RED='\e[31m'
export PALETTE_GREEN='\e[32m'
export PALETTE_BROWN='\e[33m'
export PALETTE_BLUE='\e[34m'
export PALETTE_PURPLE='\e[35m'
export PALETTE_CYAN='\e[36m'
export PALETTE_LIGHTGRAY='\e[37m'
export PALETTE_LIGHT_YELLOW='\e[93m'

# Background Color
export PALETTE_BLACK_U='\e[40m'
export PALETTE_RED_U='\e[41m'
export PALETTE_GREEN_U='\e[42m'
export PALETTE_BROWN_U='\e[43m'
export PALETTE_BLUE_U='\e[44m'
export PALETTE_PURPLE_U='\e[45m'
export PALETTE_CYAN_U='\e[46m'
export PALETTE_LIGHTGRAY_U='\e[47m'

# Normal Text
export PALETTE_RESET='\e[0m'

# workspace
export CODESPACE_ROOT=$(pwd)
export CODESPACE_DEFAULT_PATH="\$CODESPACE_ROOT\$ADO_REPO_DEFAULT_PATH"
alias cdroot='cd \$CODESPACE_ROOT'
alias cddefault='cd \$CODESPACE_DEFAULT_PATH'
alias do='dotnet'
alias ya='yarn'
# misc
alias code='f() {
    if code-insiders -v &> /dev/null; then
      code-insiders \$@;
    else
      code \$@;
    fi
};f'
alias ls='ls --color=auto'
alias ww='watch -n 1 \"date && echo -e \ &&\"'
alias refresh='exec bash'
alias bashconfig=\"code $BASH_RC_FILE\"
alias ports='lsof -n -i -P | grep TCP'
# git
alias push='git push -u azdo HEAD'
alias pull='git pull azdo'
alias sync='pull && push'
alias fetch='git fetch azdo'
alias pullmaster='git pull azdo master'
alias branch='f() {
    BRANCH_NAME=\"dev/\$AZ_DO_USERNAME/\$1\";
    git pull azdo master:main --no-tags;
    git branch \$BRANCH_NAME main --color;
    git checkout \$BRANCH_NAME;
    git push -u azdo \$BRANCH_NAME;
};f'

# change dir to the repo default folder if present (codespace is initialized),
# otherwise show the hint
if ! [ -z \$CODESPACE_DEFAULT_PATH ] 2> /dev/null && [ -d \$CODESPACE_DEFAULT_PATH ]; then
  cd \$CODESPACE_DEFAULT_PATH
elif [ \$(basename \"\$0\") != 'init' ]
then
  clear
  echo -e \"\$PALETTE_DIM\n💡  Run\$PALETTE_BLUE ./init\$PALETTE_RESET\$PALETTE_DIM when ready.\n\$PALETTE_RESET\"
fi

" >> $BASH_RC_FILE
