# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";
export PATH="$PATH:~/.local/bin:/Users/mcuber/local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

# Go exports
export GOPATH=$HOME/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aws_aliases,profile,bash_prompt,exports,aliases,functions,extra,ssl_functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# set_aws_assumerole uses assume-role script, brew install assume-role
function set_aws_assumerole(){
  if [ -z "$1" ]
    then
      PS3='Select aws assume role profile to use: ';
      vars=($(cat ~/.aws/config | awk -F'[][]' '{print $2}' | grep -oP 'assumerole-\K.*'));
      echo "Execute \"set_aws_assumerole\" to assume another role";
      select opt in "${vars[@]}" ""Quit
        do
          if [ "$opt" = "Quit" ]; then
            echo done;
            break;
          elif [[ "${vars[*]}" == *"$opt"* ]]; then
            role="assumerole-${opt}";
            echo "Assuming role named: ${role}";
            eval $(assume-role ${role});
            account_aliases=$(aws iam list-account-aliases --query 'AccountAliases' --output text);
            account_id=$(aws sts get-caller-identity --query 'Account' --output text);
            echo "Assumed role in AccountID: ${account_id} AccountAlias: ${account_aliases}";
            break;
          else
           clear;
           echo bad option;
          fi
      done
    else
      echo "Assuming role named: ${1}";
      eval $(assume-role ${1});
      account_aliases=$(aws iam list-account-aliases --query 'AccountAliases' --output text);
      account_id=$(aws sts get-caller-identity --query 'Account' --output text);
      echo "Assumed role in AccountID: ${account_id} AccountAlias: ${account_aliases}";
  fi
};

function set_aws_pro(){
  if [ -z "$1" ]
    then
      PS3='Select aws profile to use: '
      vars=(`cat ~/.aws/credentials | grep '\[*\]'| egrep -o '[^][]+'`)
      echo "Execute \"set_aws_pro profile\" to switch account";
      select opt in "${vars[@]}" ""Quit
        do
          if [ "$opt" = "Quit" ]; then
            echo done
            break
          elif [[ "${vars[*]}" == *"$opt"* ]]; then
            export AWS_DEFAULT_PROFILE=$opt;
            aws configure list;
            break
          else
           clear
           echo bad option
          fi
      done
    else
      export AWS_DEFAULT_PROFILE=$1;
      echo "Current profile is:";
      aws configure list;
  fi
};

function unset_aws_creds(){
  unset AWS_SESSION_TOKEN
  unset AWS_SECURITY_TOKEN
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_ACCESS_KEY_ID
  unset AWS_DEFAULT_PROFILE
  unset ASSUMED_ROLE
};

function ke(){
  if [[ -z "${1}" ]]
    then
      PS3='Select KUBECONFIG to export: '
      vars=($(ls -l ~/.kube/kubeconfigs.d/kubeconfig* | grep -o 'kubeconfig.*' | cut -f2- -d-))
      echo "Execute \"ke \" to export kubeconfig";
      select opt in "${vars[@]}" ""Quit
        do
          if [[ "${opt}" = "Quit" ]]; then
            echo done
            break
          elif [[ "${vars[*]}" == *"${opt}"* ]]; then
            export KUBECONFIG=~/.kube/kubeconfigs.d/kubeconfig-${opt};
            kubectl cluster-info
            break
          else
           clear
           echo bad option
          fi
      done
    else
      export KUBECONFIG=${1};
      kubectl cluster-info
  fi
};

# Recursively scan through provided directory and cat all files. Used in autocomplete ssh
recursive_scan() {
  find ${1}/* -type f | sort -u | xargs -r cat | grep "^Host " | awk '{print $2}'
};

# Git clone using specific ssh key
function git_clone_with_sshkey(){
  if [ -n "$1" ] && [ -n "$2" ] #$1 is the private key $2 is the git repo
  then
    GIT_SSH_COMMAND="ssh -i $(pwd)/$1 -F /dev/null" git clone $2
  fi
};

# Convert p7b extention file to cer and ca
function convert_p7b_to_cer_ca(){
  P7B="${1}"
  CER="${1%.p7b}.cer"
  CA="${1%.p7b}.ca"

  openssl pkcs7 \
    -print_certs \
    -inform der \
    -in "$P7B" | awk -v CER="$CER" -v CA="$CA" 'BEGIN {
      printf "" > CER
      printf "" > CA
    }
    {
      if (incert) {
        if (cert==1) printf "%s\n",$0 >> CER
        else printf "%s\n",$0 >> CA
        if ($0 == "-----END CERTIFICATE-----") {
          incert=0
          # End of cert
        }
      } else if ($0 == "-----BEGIN CERTIFICATE-----") {
        echo "----START"
        incert=1
        cert++
        if (cert==1) printf "%s\n",$0 >> CER
        else printf "%s\n",$0 >> CA
      }
    }'
};

clone () {
  local SOURCE="${1}";
  local REPO=$(echo "${1//*\//}" | sed -E 's#(\.git|/)$##');
  local TARGET_PARENT_DIR="${2:-.}";
  local TARGET_DIR="${TARGET_PARENT_DIR}/${REPO}";
  local CURRENT_BRANCH DOMAIN;
  if [[ $(echo "${SOURCE}" | grep -o '[:@/]*' | wc -l) -lt 2 ]]; then
    printf "No domain for ${SOURCE}. Iterating providers...\n\n";
    for DOMAIN in git@github.com: git@bitbucket.com:;
    do
      if clone "${DOMAIN}${SOURCE}" "${TARGET_PARENT_DIR}"; then
          return 0;
      fi;
      echo;
    done;
    return 1;
  else
    printf "${SOURCE} | ";
    local CURRENT_BRANCH;
    git clone --depth 1 "${SOURCE}" "${TARGET_DIR}" && cd "${_}" && CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && git branch --set-upstream-to=origin/"${CURRENT_BRANCH}" "${CURRENT_BRANCH}" && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*";
    local STATUS=$?;
    [[ "${STATUS}" == 0 ]] && echo "Cloned from ${SOURCE}";
    return ${STATUS};
  fi
};

function akstage() {
  prodedge=$(dig ${1} | grep -m 1 'edgekey.net' | awk '{print $5}')
  stagedge=$(echo "${prodedge}" | sed 's|.edgekey.net.|.edgekey-staging.net|')
  echo "Staging edge: ${stagedge}"
  stagip=$(ping -c 1 ${stagedge} | egrep -om 1 '([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)')
  echo "Add the following line to your /etc/hosts file"
  tput bold
  echo -e "${stagip} \t ${1} \n"
  tput sgr0
  echo "***REMEMBER TO REMOVE THIS LINE WHEN YOU ARE FINISHED TESTING***"
};

_akamai_cli_bash_autocomplete() {
  local cur opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} --generate-auto-complete )
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _akamai_cli_bash_autocomplete akamai

function fingerprint_ssh_key() {
  # argument ${1} takes in private key and generates fingerprints in different formats
  #
  local key_dir=${1}
  printf "Fingerprints: \n"
  ssh-keygen -lf /dev/stdin <<< $( ssh-keygen -f ${key_dir} -y )
  printf "If you created your key pair using third-party tool: \n"
  openssl rsa -in ${key_dir} -pubout -outform DER | openssl md5 -c
  printf "If you created your key pair using AWS: \n"
  openssl pkcs8 -in ${key_dir} -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
}

function encode_string_base64() {
  if [ -n "$1" ]
  then
    echo -n "$1" | base64;
  else
    echo "Pass in a string";
  fi
};

function chrome() {
  local site=""
  if [[ -f "$(pwd)/$1" ]]; then
    site="$(pwd)/$1"
  elif [[ "$1" =~ "^http" ]]; then
    site="$1"
  else
    site="http://$1"
  fi
  /usr/bin/open -a "/Applications/Google Chrome.app" "$site";
};

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Enable tab completion for `k` by marking it as an alias for kubectl
if type __start_kubectl &> /dev/null && [ -f /usr/local/etc/bash_completion.d/kubectl ]; then
  complete -o default -o nospace -F __start_kubectl k
fi;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Some fun
fortune -o | cowsay | lolcat
