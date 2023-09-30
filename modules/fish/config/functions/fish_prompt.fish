# Customized fish prompt
function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus

	## Git setup
	# Be informative
	set -g __fish_git_prompt_show_informative_status 1

	# Don't show some characters and states
    set -g __fish_git_prompt_char_stateseparator ""
    set -g __fish_git_prompt_char_cleanstate ""

	# Set some other characters
    set -g __fish_git_prompt_char_stagedstate " +"
    set -g __fish_git_prompt_char_dirtystate " *"
	set -g __fish_git_prompt_char_untrackedfiles " ?"
    set -g __fish_git_prompt_char_invalidstate " !"

	# Colors for those characters
    set -g __fish_git_prompt_color_dirtystate ECEA13
    set -g __fish_git_prompt_color_stagedstate 31EA13
    set -g __fish_git_prompt_color_invalidstate red --bold

	# Disable upstream showing
	set -g __fish_git_prompt_showupstream "none"
    set -g __fish_git_prompt_char_upstream_behind ""
    set -g __fish_git_prompt_char_upstream_ahead ""

	# Branch colors (using patched git prompt)
    set -g __fish_git_prompt_color_branch 10a900 --bold
	set notcleanstate yellow --bold
	set -g __fish_git_prompt_color_branch_dirtystate $notcleanstate
	set -g __fish_git_prompt_color_branch_stagedstate $notcleanstate
	set -g __fish_git_prompt_color_branch_untrackedstate $notcleanstate

    set -l color_cwd
    set -l prefix
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

	echo -n (whoami)"@$hostname: "

    # PWD
    set_color -o 00A2FD
    echo -n (prompt_pwd) ""
    set_color normal

    echo -n (fish_git_prompt 'on %s ')

    set -l pipestatus_string (__fish_print_pipestatus "[" "] " "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
    echo -n $pipestatus_string
    set_color normal

	echo ''

    set_color -o $color_cwd
    echo -n '❯ '
    set_color normal
end

