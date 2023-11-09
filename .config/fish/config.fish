# PATH additions
set PATH $PATH ~/.local/bin $FORGIT_INSTALL_DIR/bin $HOME/.config/composer/vendor/bin

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# Opeen terminal in new tab
# set PROMPT_COMMAND ${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'

set MICRO_CONFIG_HOME $HOME/.config/micro

if test -f $HOME/omni-socat/ubuntu-fish.setup.fish
    source $HOME/omni-socat/ubuntu-fish.setup.fish
end

# pnpm
if test -d $HOME/.local/share/pnpm
    set -gx PNPM_HOME $HOME/.local/share/pnpm
    set -gx PATH "$PNPM_HOME" $PATH
end

# See if apps are flagged for light theme
if test -f ~/autodarkmode-wsl/adm.fish
    source ~/autodarkmode-wsl/adm.fish
end

set -gx DISPLAY 127.0.0.1:0.0 #GWSL
set -gx PULSE_SERVER tcp:127.0.0.1 #GWSL

#set -gx DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0 #GWSL
#set -gx PULSE_SERVER tcp:(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}') #GWSL
if command -q zoxide
    zoxide init fish | source
end

set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
# xsettingsd &