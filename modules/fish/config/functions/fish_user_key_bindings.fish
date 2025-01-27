function fish_user_key_bindings
    bind \cc __fish_cancel_commandline
end

function __fish_cancel_commandline
    # Close the pager if it's open (#4298)
    commandline -f cancel

    set -l cmd (commandline)
    if test -n "$cmd"
        commandline -C 1000000
        if set -q fish_color_cancel
            echo -ns (set_color $fish_color_cancel) "^C" (set_color normal)
        else
            echo -ns "^C"
        end
        if command -sq tput
            # Clear to EOL (to erase any autosuggestion).
            echo -n (tput el; or tput ce)
        end
        for i in (seq (commandline -L))
            echo ""
        end
        commandline ""
        commandline -f execute
    end
end

