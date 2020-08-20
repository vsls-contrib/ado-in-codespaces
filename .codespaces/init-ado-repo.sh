#!/bin/bash

clear

cp -Ru . ~/ado-in-codespaces

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CACHE_FILE_PATH=~/.ado-in-codespaces-cache

if [ -f $CACHE_FILE_PATH ]; then
    source $CACHE_FILE_PATH
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

source "$SCRIPT_DIR/lib/colors.sh"

if [ -f ~/.cs-envirnment ]; then
    source ~/.cs-envirnment
fi

GREETINGS=("Bonjour" "Hello" "Salam" "Привет" "Вітаю" "Hola" "Zdravo" "Ciao" "Salut" "Hallo" "Nǐ hǎo" "Xin chào" "Yeoboseyo" "Aloha" "Namaskaram" "Wannakam" "Dzień dobry")
GREETING=${GREETINGS[$RANDOM % ${#GREETINGS[@]} ]}

echo -e $PALETTE_WHITE"\n
        ~+

                 *       +
           '                  |
         +   .-.,=\"\`\`\"=.    - o -
             '=/_       \     |
          *   |  '=._    |   
               \     \`=./\`,        '
            .   '=.__.=' \`='      *
   +                         +
        O      *        '       .
"$PALETTE_RESET

echo -e $PALETTE_GREEN"\n\n     🖖 👽  $GREETING, Codespacer 👽 🖖\n"$PALETTE_RESET

sleep 1s

echo -e $PALETTE_PURPLE"\n🏃 Lets setup the Codespace"$PALETTE_RESET

sleep 0.25s








if [ -z "$ADO_REPO_URL" ]; then

    unset ADO_REPO_URL_SUFFIX;
    if [ -z "$ADO_REPO_URL" ]; then
        ADO_REPO_URL_SUFFIX=""
    else
        ADO_REPO_URL_SUFFIX=$PALETTE_CYAN"(➥ to reuse *$ADO_REPO_URL*)"$PALETTE_RESET
    fi

    echo -e $PALETTE_CYAN"\n- Please provide your AzDO repo URL\n"$PALETTE_RESET

    printf " ↳ AzDO repo URL$ADO_REPO_URL_SUFFIX: $PALETTE_PURPLE"

    read ADO_REPO_URL_INPUT

    echo -e " $PALETTE_RESET"

    if [ -z "$ADO_REPO_URL_INPUT" ]; then
        if [ -z "$ADO_REPO_URL" ]; then
            echo -e $PALETTE_RED"  🧱 No link - no {tbd}"$PALETTE_RESET
            exit 1
        else
            ADO_REPO_URL_INPUT=$ADO_REPO_URL
            echo -e $PALETTE_DIM"  * reusing *$ADO_REPO_URL_INPUT* as AzDO repo URL.\n"$PALETTE_RESET
        fi
    fi

    if [ "$ADO_REPO_URL" != "$ADO_REPO_URL_INPUT" ]; then
        export ADO_REPO_URL=$ADO_REPO_URL_INPUT

        echo "export ADO_REPO_URL=$ADO_REPO_URL" >> $CACHE_FILE_PATH
    fi

fi




unset AZ_DO_USERNAME_SUFFIX;
if [ -z "$AZ_DO_USERNAME" ]; then
    AZ_DO_USERNAME_SUFFIX=""
else
    AZ_DO_USERNAME_SUFFIX=$PALETTE_CYAN"(➥ to reuse *$AZ_DO_USERNAME*)"$PALETTE_RESET
fi

echo -e $PALETTE_CYAN"\n- Please provide your AzDO username\n"$PALETTE_RESET

printf " ↳ AzDO Username$AZ_DO_USERNAME_SUFFIX: $PALETTE_PURPLE"

read AZ_DO_USERNAME_INPUT

echo -e " $PALETTE_RESET"

if [ -z "$AZ_DO_USERNAME_INPUT" ]; then
    if [ -z "$AZ_DO_USERNAME" ]; then
        echo -e $PALETTE_RED"  🗿 No name - no fame"$PALETTE_RESET
        exit 1
    else
        AZ_DO_USERNAME_INPUT=$AZ_DO_USERNAME
        echo -e $PALETTE_DIM"  * reusing *$AZ_DO_USERNAME_INPUT* as AzDO username.\n"$PALETTE_RESET
    fi
fi

IFS=@ read -r username domain <<< "$AZ_DO_USERNAME_INPUT"
if [ ! -z "$domain" ]; then
    AZ_DO_USERNAME_INPUT="$username"
    echo -e $PALETTE_DIM"  * using *$AZ_DO_USERNAME_INPUT* as AzDO username.\n"$PALETTE_RESET
fi

if [ "$AZ_DO_USERNAME" != "$AZ_DO_USERNAME_INPUT" ]; then
    export AZ_DO_USERNAME=$AZ_DO_USERNAME_INPUT

    echo "export AZ_DO_USERNAME=$AZ_DO_USERNAME" >> $CACHE_FILE_PATH
fi








echo -e $PALETTE_CYAN"- Thanks, *$AZ_DO_USERNAME*! Please provide your AzDO PAT\n"$PALETTE_RESET

unset AZ_DO_PASSWORD_SUFFIX;
if [ -z "$AZ_DO_PAT" ]; then
    AZ_DO_PASSWORD_SUFFIX=""
else
    AZ_DO_PASSWORD_SUFFIX=$PALETTE_CYAN"(➥ to reuse old PAT)"$PALETTE_RESET
fi

# reading the PAT
unset CHARCOUNT
unset AZ_DO_PAT_INPUT
PROMPT=" ↳ PAT code[R/W] + packaging[R]$AZ_DO_PASSWORD_SUFFIX: "

stty -echo

CHARCOUNT=0
while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
do
    # Enter - accept password
    if [[ $CHAR == $'\0' ]] ; then
        break
    fi

    # Backspace
    if [[ $CHAR == $'\177' ]] ; then
        if [ $CHARCOUNT -gt 0 ] ; then
            CHARCOUNT=$((CHARCOUNT-1))
            PROMPT=$'\b \b'
            AZ_DO_PAT_INPUT="${PASSWORD%?}"
        else
            PROMPT=''
        fi
    else
        CHARCOUNT=$((CHARCOUNT+1))
        PROMPT='*'
        AZ_DO_PAT_INPUT+="$CHAR"
    fi
done

stty echo
echo -e " "$PALETTE_RESET

# check if PAT set
if [ -z ${AZ_DO_PAT_INPUT} ]; then
    if [ -z "$AZ_DO_PAT" ]; then
        echo -e $PALETTE_RED"\n  🐢  No PAT - Zero FLOPS per watt\n"$PALETTE_RESET
        exit 1
    else
        AZ_DO_PAT_INPUT=$AZ_DO_PAT
        echo -e $PALETTE_DIM"\n  * reusing the old PAT."$PALETTE_RESET
    fi
fi

EMPTY_STRING=""
CLEAN_ADO_ORIGIN="${ADO_REPO_URL/https\:\/\//$EMPTY_STRING}"

git remote remove github-origin &>/dev/null
git remote rename origin github-origin &>/dev/null

#git remote remove origin
git remote add origin https://$AZ_DO_USERNAME:$AZ_DO_PAT_INPUT@$CLEAN_ADO_ORIGIN

GIT_DEFAULT_BRANCH_NAME=$(git remote show origin | grep "HEAD branch\: " | sed 's/HEAD branch\: //g' | xargs)

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the repo\n"$PALETTE_RESET

git reset --hard
git checkout main

git branch --track github-main

# clone the AzDO repo
git pull origin $GIT_DEFAULT_BRANCH_NAME:$GIT_DEFAULT_BRANCH_NAME --force --no-tags

git checkout $GIT_DEFAULT_BRANCH_NAME &>/dev/null

if [ "$AZ_DO_PAT" != "$AZ_DO_PAT_INPUT" ]; then
    export AZ_DO_PAT=$AZ_DO_PAT_INPUT
    AZ_DO_PAT_BASE64=$(echo -n $AZ_DO_PAT | base64)
    # replace env variable reference in the .npmrc
    sed -i -E "s/_password=.+$/_password=$AZ_DO_PAT_BASE64/g" ~/.npmrc
    # write the token to the env file
    echo -e "export AZ_DO_PAT=$AZ_DO_PAT" >> ~/.cs-envirnment
fi

if [ ! -d $CODESPACE_DEFAULT_PATH ]; then
    echo -e $PALETTE_RED"\n ❗ Could not clone the \`$ADO_REPO_URL\` repo, are the credentials correct?\n"$PALETTE_RESET
    exit 1
fi

cd $CODESPACE_DEFAULT_PATH

USER_POST_CREATE_COMMAND_FILE=~/ado-in-codespaces/.devcontainer/post-create-command.sh
if [ -f $USER_POST_CREATE_COMMAND_FILE ]; then
    echo -e $PALETTE_CYAN"\n Executing the post create command..\n"$PALETTE_RESET

    . $USER_POST_CREATE_COMMAND_FILE
fi

exec bash

