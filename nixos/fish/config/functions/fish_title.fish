function fish_title
    # emacs is basically the only term that can't handle it.
    if not set -q INSIDE_EMACS
		echo -n (whoami)@(hostname)
		echo -n ': '
		if test (status current-command) = "fish"
			set -l fish_prompt_pwd_dir_length 0
			echo (prompt_pwd)
		else
			echo $argv[1]
		end
    end
end
