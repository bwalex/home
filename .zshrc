PATH=~/bin${PATH:+:}$PATH

SAVEHIST=5000
HISTSIZE=8000
HISTFILE=~/.zshhistory
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
#setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt PUSHD_IGNORE_DUPS

autoload -U colors; colors

typeset -A title
title[start]="\e]0;"
title[end]="\a"


if [[ $TERM == (xterm|screen)* && $oldterm != $TERM$WINDOWID ]]; then
	SHLVL=1
	export oldterm=$TERM$WINDOWID
fi

REPORTTIME=1
TIMEFMT="%E=%U+%S"

#PS1="%(?..%{${fg_bold[red]}%}%?%{$reset_color%} )%(2L.%{${fg_bold[yellow]}%}<%L>%{$reset_color%} .)%B%(#.%{${bg[red]}%}.)%m %(#..%{$fg[green]%})%#%{$reset_color%}%b "
#RPS1=" %{${fg_bold[green]}%}%~%{${fg_bold[black]}%}|%{${fg_bold[blue]}%}%(t.DING!.%*)%{$reset_color%}"

setopt PROMPT_PERCENT
# Substitute vars.  Notice that we're in "", so $vars here are
# replaced already here.  All dynamic content needs to go
# in escaped \$vars.
#setopt PROMPT_SUBST
function prompt_generate {
	PS1=""
	# time
	prompt_time
	# switch to red background when root
	#PS1="$PS1%(#.%{${bg[red]}%}.)"
	# hostname
	PS1="$PS1%B%m%b:"
	# path
	PS1="$PS1%{${fg_bold[black]}%}%~%b "
	# git dynamic content, i.e. branch name
	prompt_git
	# history number
	#PS1="$PS1%{${fg[magenta]}%}!%!$reset_color "
	# jobs display
	prompt_jobs
	# shell nesting
	PS1="$PS1%(2L.%{${fg_bold[yellow]}%}<%L>%{$reset_color%} .)"
	# tty name
	#PS1="$PS1%l "
	# start second line
	PS1="$PS1
"
	# If we're in paste mode, forget all the fancyness and only do
	# the basic prompt.
	#if [[ -n $paste_mode ]] {
	#	PS1=""
	#}
	# return value
	PS1="$PS1%(?..%{${fg_bold[red]}%}%?%{$reset_color%} )"
	# prompt!
	#PS1="$PS1%(#.%{${fg[green]%}}%B.%%%{$reset_color%} "
	#PS1="$PS1%(..%{$fg[green]%}%%) %{$reset_color%}"
	#PS1="$PS1%(#.%{${fg[red]%}%B.%{$fg[green]%})%# %{$reset_color%}"
	 PS1="$PS1%(!.%{$fg_bold[red]%}.%{$fg[green]%})%# %{$reset_color%}"
}

typeset -g lastding
function prompt_time {
	local t
	local -a curtime
	local hour
	local minute

	curtime=(${(@s,:,)$(print -Pn "%D{%H:%M}")})
	hour=$curtime[0]
	minute=$curtime[2]

	t="%*"
	if [[ $minute -eq 0 && $lastding -ne $hour ]]; then
		lastding=$hour
		# not using ^G here, because then cat'ing
		# this file will beep.
		t="DING!$(printf '\a')   "
	fi
	PS1="$PS1%{${fg_bold[blue]}%}$t%{$reset_color%} "
}

function prompt_git {
	local ref

	ref=$(git symbolic-ref HEAD 2>/dev/null)
	ref=${ref#refs/heads/}
	if [[ -n $ref ]] {
		# real symbolic ref
		PS1="$PS1%{${fg[cyan]}%}$ref%{$reset_color%} "
		return
	}

	# maybe detached?
	ref=$(git rev-parse HEAD 2>/dev/null)
	ref=${ref[0,10]}
	if [[ -n $ref ]] {
		# detached head, print commitid
		PS1="$PS1%{${bg[cyan]}${fg[black]}%}$ref%{$reset_color%} "
		return
	}
}

function prompt_jobs {
	# from http://www.miek.nl/blog/archives/2008/02/20/my_zsh_prompt_setup/index.html
	local js
	local jobno

	js=()
	for jobno (${(k)jobstates}) {
		local fullstate=$jobstates[$jobno]
		local state="${${(@s,:,)fullstate}[2]}"
		js+=($jobno${state//[^+-]/})
	}
	if [[ $#js -gt 0 ]]; then
		PS1="$PS1%{${fg[yellow]}%}[${(j:,:)js}]%{$reset_color%} "
	fi
}

function precmd {
	title_generate
	prompt_generate
}

function title_generate {}

if [[ $TERM == (xterm|screen)* ]]; then
	function title_generate {
		print -Pn "${title[start]}%n@%m:%~${title[end]}"
	}

	function preexec {
		emulate -L zsh
		local -a cmd; cmd=(${(z)1})
		local -a checkjobs

		case $cmd[1] in
		fg|wait)
			if (( $#cmd == 1 ))
			then
				checkjobs=%+
			else
				checkjobs=$cmd[2]
			fi
			;;
		%*)
			checkjobs=$cmd[1]
			;;
		esac

		print -n "${title[start]}"

		if [[ -n "$checkjobs" ]]
		then
			# from: http://www.zsh.org/mla/workers/2000/msg03990.html
			local -A jt; jt=(${(kv)jobtexts})	# Copy jobtexts for subshell
			builtin jobs -l $checkjobs 2>/dev/null >>(read num rest
				cmd=(${(z)${(e):-\$jt$num}})
				print -nr "$cmd")
		else
			print -nr "$cmd"
		fi

		print -Pn " | %* | "
		print -Pn "%n@%m:%~"
		print -n "${title[end]}"
	}
fi

if which todo >/dev/null 2>&1; then
	function chpwd {
		# only print stuff in the interactive case
		[[ ! -o interactive ]] && return

		todo
	}
fi

if [[ -r ~/.aliasrc ]]; then
	source ~/.aliasrc
fi

umask 22

if which vim >/dev/null 2>&1; then
	export EDITOR=`which vim`
fi
export PAGER=less
export BLOCKSIZE=K
lesspipe=$(which lesspipe.sh 2>/dev/null) || \
lesspipe=$(which lesspipe 2>/dev/null)
if test -n "$lesspipe"; then
	export LESSOPEN="|$lesspipe %s"
fi

if which keychain >/dev/null 2>&1; then
	[ -f ~/.ssh/id_rsa ] && keychain -q id_rsa --nogui
	[ -f ~/.ssh/id_dsa ] && keychain -q id_dsa --nogui
	source ~/.keychain/$HOST-sh
fi

bindkey -e
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
autoload -U down-line-or-beginning-search
autoload -U up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
autoload run-help
bindkey '\eOP' run-help
bindkey '\e[M' run-help
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word
bindkey '\e[3~' delete-char
#WORDCHARS=${WORDCHARS//[\/&.;=]}
autoload -U select-word-style
select-word-style bash
zstyle ':zle:transpose-words' word-style shell
setopt NO_FLOW_CONTROL

autoload -U compinit; compinit

if [[ -r ~/.zshrc.local ]]; then
	source ~/.zshrc.local
fi

source ~/.profile

cd .
