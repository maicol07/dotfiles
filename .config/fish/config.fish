#if status is-interactive
    # Commands to run in interactive sessions can go here
#end

#begin
#    set -l HOSTNAME (hostname)
#    if test -f ~/.keychain/$HOSTNAME-fish
#        source ~/.keychain/$HOSTNAME-fish
#    end
#end

# PATH additions
set PATH $PATH ~/.local/bin $FORGIT_INSTALL_DIR/bin $HOME/.config/composer/vendor/bin

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# Opeen terminal in new tab
# set PROMPT_COMMAND ${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'

set MICRO_CONFIG_HOME $HOME/.config/micro

export GPG_TTY=(tty)

# Are we in the bottle?
#if set -q $INSIDE_GENIE
#  exec /usr/bin/genie -s
#end

. $HOME/omni-socat/ubuntu-fish.setup.fish
# pnpm
set -gx PNPM_HOME "/home/maicol07/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end