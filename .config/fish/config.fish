# PATH additions
# set PATH $PATH 
fish_add_path ~/.local/bin $FORGIT_INSTALL_DIR/bin $HOME/.config/composer/vendor/bin /snap/aws-cli/current/bin

# setxkbmap -layout it

if test -f ~/.Xresources
    xrdb -merge ~/.Xresources
end

if status --is-interactive
    # export (dbus-launch)

    # Opeen terminal in new tab
    # set PROMPT_COMMAND ${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'

    set MICRO_CONFIG_HOME $HOME/.config/micro

    # if test -f $HOME/omni-socat/ubuntu-fish.setup.fish
    #     source $HOME/omni-socat/ubuntu-fish.setup.fish
    # end

    # pnpm
    if test -d $HOME/.local/share/pnpm
        set -gx PNPM_HOME $HOME/.local/share/pnpm
        set -gx PATH "$PNPM_HOME" $PATH
    end
    
    if command -q zoxide
        zoxide init fish | source
    end
    
    set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk-amd64

    # See if apps are flagged for light theme
    # if test -f ~/autodarkmode-wsl/adm.fish
    #     # echo $DBUS_SESSION_BUS_ADDRESS
    #     # echo $DISPLAY
    #     source ~/autodarkmode-wsl/adm.fish
    # end

    # X410
    export DISPLAY=localhost:0.0
    # set -gx DISPLAY 127.0.0.1:0.0 #GWSL
    # set -gx PULSE_SERVER tcp:127.0.0.1 #GWSL

    [ -f ~/.inshellisense/key-bindings.fish ] && source ~/.inshellisense/key-bindings.fish

    #eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# Must be here to work with async plugin
starship init fish | source