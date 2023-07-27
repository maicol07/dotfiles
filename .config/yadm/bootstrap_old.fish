#!/bin/fish
set arch (dpkg --print-architecture)

function eget_install --description 'Get and install a deb package from Github' -a repo name
    if test -z $name
        set splitted (string split "/" $repo)
        set name $splitted[2]
    end

    echo "Downloading and installing $name..."
    eget $repo -a "$arch.deb" -a $name"_" --download-only --to package.deb -q
    sudo dpkg -i package.deb
    rm package.deb
end

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


# Eget
curl -o eget.sh https://zyedidia.github.io/eget.sh
shasum -a 256 eget.sh # verify with hash below
bash eget.sh
sudo mv eget /usr/local/bin/eget
rm eget.sh

eget_install "sharkdp/bat"
eget_install "Peltoche/lsd"

# Micro
eget_install "zyedidia/micro"
micro -plugin install aspell bookmark detectindent editorconfig filemanager fish fzf jump quoter wc

# Fisher
cp $HOME/.config/fish/fish_plugins $HOME/.config/fish/fish_plugins_to_install
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
read -za plugins < $HOME/.config/fish/fish_plugins_to_install
fisher install $plugins
rm $HOME/.config/fish/fish_plugins_to_install

# PPAs
sudo nala update

# Packages
sudo nala install -y fzf neofetch tree ttf-mscorefonts-installer xclip tldr zip unzip python3 python-is-python3 fonts-noto-color-emoji -y

read_confirm "Install web-backend related packages (PHP, MySQL)?"
if test $status -eq 0
    sudo add-apt-repository ppa:ondrej/php -y
    sudo nala update
    sudo nala install -y mariadb-server php-cli php8.1-xdebug
    # Fix for root access without password
    echo "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('');" | sudo mysql
end

read_confirm "Install utilities for WSL (wslu, Git w/ssh, Windows Hello sudo)?"
if test $status -eq 0
    sudo nala install -y wslu

    # SSH with Git on WSL
    sudo cp $HOME/.config/yadm/git-wsl /usr/bin/git-wsl
    sudo chmod +x /usr/bin/git-wsl

    # WSL sudo Windows Hello
    read_confirm "Do you want to install WSL Hello Sudo and use sudo with Windows Hello?"
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

read_confirm "Install Synaptic (GUI package manager)?"
if test $status -eq 0
    sudo nala install -y synaptic
end

read_confirm "Download WSL pinentry (for GPG)?"
if test $status -eq 0
    wget https://raw.githubusercontent.com/diablodale/pinentry-wsl-ps1/master/pinentry-wsl-ps1.sh -o $HOME/pinentry-wsl-ps1.sh
    echo "Check configuration at https://github.com/diablodale/pinentry-wsl-ps1"
end

read_confirm "Install Omni SSH Agent?"
if test $status -eq 0
    mkdir -p $HOME/omni-socat
    curl -sL https://raw.githubusercontent.com/masahide/OmniSSHAgent/main/hack/ubuntu-fish.setup.fish -o $HOME/omni-socat/ubuntu-fish.setup.fish
end

read_confirm "Want to set Fish shell as default shell?"
if test $status -eq 0
    chsh -s (which fish)
end



set_color green;
echo -n "Dotfiles applied! Please restart your shell to use Fish shell if you set it as default shell. Some things you can check and customize: Git config (especially user name and email).";
set_color normal