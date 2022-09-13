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
eget_install "zyedidia/micro"

# Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
read -za plugins < .config/fish/fish_plugins
fisher install $plugins

# PPAs
sudo nala update

# Packages
sudo nala install fzf neofetch tree ttf-mscorefonts-installer xclip -y

if test -z read_confirm "Install web related packages?"
    sudo add-apt-repository ppa:ondrej/php -y
    sudo nala update
    sudo nala install mariadb-server php-cli php8.1-xdebug
end

if test -z read_confirm "Install WSL utils?"
    sudo nala install wslu

    # WSL sudo Windows Hello
    set install_wsl_hello_sudo (read_confirm "Do you want to install WSL Hello Sudo?")
    if test -z install_wsl_hello_sudo
        wget http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz
        tar xvf release.tar.gz
        cd release
        ./install.sh
        cd ..
        rm release
        rm release.tar.gza
    end
end

if test -z read_confirm "Install GUI packages?"
    sudo nala install pinentry-qt synaptic
end