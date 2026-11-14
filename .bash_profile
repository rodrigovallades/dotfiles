# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{bash_colors,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# init nvm (NVM_DIR must be user-writable; /usr/local is root-owned on Apple Silicon)
export NVM_DIR="$HOME/.nvm"
export NVM_SYMLINK_CURRENT=true
mkdir -p "$NVM_DIR"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"

# Ruby paths
export GEM_HOME="$(brew --prefix)/opt/gems"
export GEM_PATH="$GEM_HOME/bin"

# PHP path
export PHP_PATH="$(brew --prefix)/opt/php@7.1/bin"

# init brew
PATH="./node_modules/.bin:$PATH"
PATH="$(brew --prefix)/sbin:$PATH"
PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
PATH="$PHP_PATH:$PATH"
PATH="$GEM_PATH:$PATH"

if hash fasd 2>/dev/null; then
	eval "$(fasd --init auto)"
	_fasd_bash_hook_cmd_complete sb
fi

eval $(thefuck --alias)

# bash-completion (Homebrew's) needs bash 4+; login shells may run the system bash 3.2
if (( BASH_VERSINFO[0] >= 4 )) && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	. "$(brew --prefix)/share/bash-completion/bash_completion"
fi
