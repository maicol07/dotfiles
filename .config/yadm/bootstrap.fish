#!/bin/fish
set arch (dpkg --print-architecture)

function read_confirm --description 'Ask the user for confirmation' --argument prompt
    if test -z "$prompt"
        set prompt "Continue?"
    end 

    while true
        read -p 'set_color green; echo -n "$prompt [y/N]: "; set_color normal' -l confirm

        switch $confirm
            case Y y 
                return 0
            case '' N n 
                return 1
        end 
    end 
end

### Fisher ###
# Check if fisher is installed
if not test -f $HOME/.config/fish/functions/fisher.fish
    echo "Fisher not found. Installing..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

mv $HOME/.config/fish/fish_plugins $HOME/.config/fish/fish_plugins_to_install
# Diff installed packages and new to install
set -l installed_plugins (fisher list | awk '{print $1}')
set -l new_plugins (cat $HOME/.config/fish/fish_plugins_to_install)
set -l plugins_to_install (echo $new_plugins $installed_plugins | tr ' ' '\n' | sort | uniq -u)
# read -za plugins < $HOME/.config/fish/fish_plugins_to_install
if test -n "$plugins_to_install"
    echo "Installing new fisher plugins..."
    fisher install (string join " " $plugins_to_install)
end
rm $HOME/.config/fish/fish_plugins_to_install

# Custom repos
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg | sudo apt-key add -
curl -SsL https://packages.httpie.io/deb/KEY.gpg | apt-key add -
curl -SsL -o /etc/apt/sources.list.d/httpie.list https://packages.httpie.io/deb/httpie.list
grep -q "^deb .*marwanhawari/stew" /etc/apt/sources.list /etc/apt/sources.list.d/* || sudo add-apt-repository ppa:marwanhawari/stew
sudo nala update

sudo nala install kdialog stew -y

kdialog --title "Dotfiles" --yesno "Do you want to apply dotfiles? This will overwrite your current configuration."
if test $status -eq 1
    exit 1
end

set packages (kdialog --checklist "Select which package you want to install (recommended options are preselected):" \
    "sharkdp/bat" "Bat - A cat clone with syntax highlighting and Git integration." on \
    "Peltoche/lsd" "lsd - The next gen file listing command. Backwards compatible with ls." on \
    "zyedidia/micro" "Micro - A modern file editor." on \
    "fzf" "fzf - A command-line fuzzy finder." on \
    "neofetch" "neofetch - A command-line system information tool." on \
    "tree" "tree - A recursive directory listing command." on \
    "ttf-mscorefonts-installer" "ttf-mscorefonts-installer - Microsoft core fonts." off \
    "xclip" "xclip - Command line interface to the X11 clipboard (recommended if you are using micro and X11/WSLg)." on \
    "dandavison/delta" "Delta - A viewer for git and diff output." on \
    "tldr" "TLDR - A collection of community-maintained help pages for command-line tools." on \
    "zip" "zip - A compression and file packaging/archive utility." on \
    "unzip" "unzip - A compression and file packaging/archive utility." on \
    "python3" "python3 - An interpreted, high-level, general-purpose programming language." on \
    "python-is-python3" "python-is-python3 - A transitional package that ensures that python is python3." on \
    "fonts-noto-color-emoji" "fonts-noto-color-emoji - color emoji font from Google." on \
    "bootandy/dust" "dust - A more intuitive version of du in rust." on \
    "duf" "duf - Disk Usage/Free Utility - a better 'df' alternative." on \
    "sharkdp/fd" "fd - A simple, fast and user-friendly alternative to 'find'." on \
    "broot" "broot - A new way to see and navigate directory trees." on \
    "choose" "choose - A fuzzy finder in rust." on \
    "ClementTsang/bottom" "bottom - A cross-platform graphical process/system monitor." on \
    "gping" "gping - Ping, but with a graph." on \
    "httpie" "httpie - A user-friendly cURL replacement." on \
    "zoxide" "zoxide - A fast cd command that learns your habits." on \
    "dandavison/delta" "delta - A syntax-highlighting pager for git, diff, and grep output." on \
    "tldr-pages/tlrc" "tlrc - A tldr client written in Rust" on \
    "jesseduffield/lazygit" "lazygit - A git TUI" on \
    "glow" "glow - Render markdown in CLI" on \
    "dog" "dog - A command-line DNS client." on)

set nala_packages ""
for package in $packages
    if test (echo $package | grep -c "/") -gt 0
        stew install $package
    else
        set nala_packages "$nala_packages $package"
    end
end

if test -n "$nala_packages"
    sudo nala install -y $nala_packages
end

if string match -q "*micro*" $packages
    micro -plugin install aspell bookmark detectindent editorconfig filemanager fish fzf jump quoter wc
end

kdialog --title "Web Backend" --yesno "Do you want to install web-backend related packages (PHP, MySQL, XDebug)?"
if test $status -eq 0
    sudo add-apt-repository ppa:ondrej/php -y
    sudo nala update
    sudo nala install -y mariadb-server php-cli php8.1-xdebug
    # Fix for root access without password
    echo "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('');" | sudo mysql
end

grep -i microsoft /proc/version
if test $status -eq 0
    kdialog --title "WSL" --yesno "Do you want to install utilities for WSL (wslu, Git w/ssh, Windows Hello sudo)?"
    if test $status -eq 0
        sudo nala install -y wslu

        # SSH with Git on WSL
        sudo cp $HOME/.config/yadm/git-wsl /usr/bin/git-wsl
        sudo chmod +x /usr/bin/git-wsl

        # WSL sudo Windows Hello
        kdialog --title "WSL" --yesno "Do you want to install WSL Hello Sudo and use sudo with Windows Hello?"
        if test $status -eq 0
            wget http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz
            tar xvf release.tar.gz
            ./release/install.sh
            rm release
            rm release.tar.gz
        end

        wget https://github.com/Chronial/wsl-sudo/raw/master/wsl-sudo.py
        sudo mv wsl-sudo.py /usr/local/share
        alias --save wudo "python3 /usr/local/share/wsl-sudo.py"
    end
end

kdialog --title "Synaptic" --yesno "Do you want to install Synaptic (GUI package manager)?"
if test $status -eq 0
    sudo nala install -y synaptic
end

# read_confirm "Download WSL pinentry (for GPG)?"
# if test $status -eq 0
#     wget https://raw.githubusercontent.com/diablodale/pinentry-wsl-ps1/master/pinentry-wsl-ps1.sh -o $HOME/pinentry-wsl-ps1.sh
#     echo "Check configuration at https://github.com/diablodale/pinentry-wsl-ps1"
# end

kdialog --title "Omni SSH Agent" --yesno "Do you want to install Omni SSH Agent?"
if test $status -eq 0
    mkdir -p $HOME/omni-socat
    curl -sL https://raw.githubusercontent.com/masahide/OmniSSHAgent/main/hack/ubuntu-fish.setup.fish -o $HOME/omni-socat/ubuntu-fish.setup.fish
end

kdialog --title "Fish shell as default" --yesno "Do you want to set Fish shell as default shell for your user?"
if test $status -eq 0
    chsh -s (which fish)
end

set_color green;
echo -n "Dotfiles applied! Please restart your shell to use Fish shell if you set it as default shell. Some things you can check and customize: Git config (especially user name and email).";
set_color normal