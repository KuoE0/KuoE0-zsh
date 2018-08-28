if zplug check sindresorhus/pure; then
	# Use single quote to allow the function to be evaluated every time not being evaluated while assigning the prompt.
	local PROMPT='%(?..%F{red}$(nice_exit_code)${PURE_PROMPT_SYMBOL:-❯})%F{magenta}${PURE_PROMPT_SYMBOL:-❯}%f '
fi

if zplug check zsh-users/zsh-history-substring-search; then
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bold,underline'
	HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'
	HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='l'
    bindkey '\eOA' history-substring-search-up # up key
    bindkey '\eOB' history-substring-search-down # down key
fi

if zplug check zsh-users/zsh-autosuggestions; then
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=236'
fi
