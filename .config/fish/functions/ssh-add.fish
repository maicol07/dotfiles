function ssh-add --wraps=ssh-add.exe --description 'alias ssh-add ssh-add.exe'
  ssh-add.exe $argv
        
end
