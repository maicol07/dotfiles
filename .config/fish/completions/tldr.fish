complete -c tldr -s h -l help        -d "Print help" -f
complete -c tldr -s v -l version     -d "Print version" -f
complete -c tldr -s u -l update      -d "Update the cache" -f
complete -c tldr -s p -l platform    -d "Specify the platform to use [default: linux]" -xa "linux osx sunos windows common android freebsd netbsd openbsd"
complete -c tldr -s l -l list        -d "List all pages in the current platform" -f
complete -c tldr -s a -l list-all    -d "List all pages" -r
complete -c tldr -s i -l info        -d "Show cache information (installed languages and the number of pages)" -f
complete -c tldr -s r -l render      -d "Render the specified markdown file" -r
complete -c tldr -s L -l language    -d "Specify the languages to use" -r
complete -c tldr -s R -l raw         -d "Print pages in raw markdown instead of rendering them" -f
complete -c tldr -l no-raw           -d "Render pages instead of printing raw file contents (overrides --raw)" -f
complete -c tldr -s q -l quiet       -d "Suppress status messages" -f
complete -c tldr -l config           -d "Specify an alternative path to the config file" -r
complete -c tldr -l color            -d "Specify when to enable color [default: auto]" -xa "auto always never"
complete -c tldr -s c -l compact     -d "Strip empty lines from output" -f
complete -c tldr -l no-compact       -d "Do not strip empty lines from output (overrides --compact)" -f
complete -c tldr -s o -l offline     -d "Do not update the cache, even if it is stale" -f
complete -c tldr -l clean-cache      -d "Clean the cache" -f
complete -c tldr -l gen-config       -d "Print the default config" -f
complete -c tldr -l config-path      -d "Print the default config path and create the config directory" -f


function __tldr_commands
    tldr --list | string replace -a -r "', '" "\n" | string replace -a -r "\['|'\]" ""
end

complete -f -c tldr -a "(__tldr_commands)"