function startOSX --wraps=/home/maicol07/OSX-KVM/OpenCore-Boot.sh --description 'alias startOSX /home/maicol07/OSX-KVM/OpenCore-Boot.sh'
  cd /home/maicol07/OSX-KVM
  echo "Starting MacOS and SPICE server: spice://localhost:5930"
  ./OpenCore-Boot.sh $argv
        
end
