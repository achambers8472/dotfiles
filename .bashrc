# Load system defaults

source /etc/bashrc > /dev/null 2>&1

ac-envvar-push-front() {
    local varname="${1}"
    shift
    for ((i=$#;i>0;i--)) ; do
        newvalue="${!i}"
        if [[ -z "${!varname:-}" ]] ; then
            export "${varname}"="${newvalue}:"
        elif [[ ":${!varname}:" != *":${newvalue}:"* ]] ; then
            export "${varname}"="${newvalue}:${!varname}"
        fi
    done
}

# Terminal settings
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend
shopt -s checkwinsize
export PS1="\u@\h > "
export PS2="     > "
export EDITOR=vim
export TMOUT=0
unset BASH_ENV

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# File settings
umask 022

# Screen settings
export SCREENDIR="$HOME/.screen"
mkdir --mode=700 --parents "$SCREENDIR"

# PATH settings
prefix="${HOME}/git/ac-essentials"
ac_python="${prefix}/ac-python"
ac_chroma_utils="${HOME}/git/ac-chroma-utils"
ac-envvar-push-front PATH \
    "${prefix}/bin" \
    "${prefix}/lib" \
    "${ac_chroma_utils}" \
    "${HOME}/bin" \
    "${HOME}/local/bin" \
    "${HOME}/.local/bin" \
    "${HOME}/local/anaconda2/bin"
ac-envvar-push-front MANPATH \
    "${HOME}/man" \
    "${HOME}/share/man"
ac-envvar-push-front PYTHONPATH "." "${ac_python}"

# Aliases
alias ls='ls --color=auto'
alias emacs='emacs --no-window-system'
alias watch='watch --difference=cumulative'
alias rsync='rsync --archive --verbose --progress --partial --human-readable --compress'
alias du='du --summarize --human-readable'
alias mv='mv --interactive'
alias df='df --human-readable'

# Functions
function retry {
    while ! $@ ; do : ; done
}

# eval "$(dircolors ${AC_ESSENTIALS_DIR}/dircolors/dircolors.ansi-light)"
unset LS_COLORS

if [[ "${TERM}" == "xterm" && "${COLORTERM}" == gnome-terminal ]] ; then
	export TERM=xterm-256color
fi

base16_script="${prefix}/base16-shell/scripts/base16-default-dark.sh"
if [[ $- == *i* ]] ; then
    if [[ -s "${base16_script}" ]] ; then
        source "${base16_script}"
    fi
fi

# Host-specific settings
case "$(ac-hostname)" in
    eddie)
        JHOME=/remote/accounts/jzanotti
        export PATH=/remote/accounts/jzanotti/bin.Linux:/home/eddie/jzanotti/opt/install/Canopy64/bin/:$PATH
        export QA_LOGGER_PROP=/remote/accounts/jzanotti/etc/qa_log4cpp.properties
        export LD_LIBRARY_PATH="${JHOME}/lib:/home/eddie/jzanotti/opt/install/guile-1.8.1/lib:$LD_LIBRARY_PATH"
        export GLI_HOME=${JHOME}/share
        export UKQCDSF_ANALYSIS=/home/eddie/achamber/qcd/ukqcdsf_analysis
        export QA_GUILE_GPDLIB=/home/eddie/jzanotti/qcd/src/qa/evff/gpdlib.scm
        export CCACHE_DIR=/home/eddie/achamber/.ccache/

        export PATH="/home/eddie/achamber/bin:${PATH}"
        export PATH="/home/eddie/achamber/local/qcdsfa-20140729+:${PATH}"
        export PATH="/home/eddie/achamber/local/anaconda2/bin:${PATH}"

        export MANPATH="/home/eddie/achamber/man:${MANPATH}"
        ;;
    erwin)
		export WORK=/raid/achambers
        JZANOTTI_HOME=/home/accounts/jzanotti
        export PATH="${HOME}/local/qcdsfa-20140729+:${JZANOTTI_HOME}/bin:$PATH"
        export QA_LOGGER_PROP=${JZANOTTI_HOME}/etc/qa_log4cpp.properties
        export LD_LIBRARY_PATH="${JZANOTTI_HOME}/lib:${JZANOTTI_HOME}/opt/install/guile-1.8.1/lib:$LD_LIBRARY_PATH"
        export GLI_HOME=${JZANOTTI_HOME}/share
        export UKQCDSF_ANALYSIS=~/qcd/ukqcdsf_analysis
        #export QA_GUILE_GPDLIB=${JZANOTTI_HOME}/qcd/src/qa/evff/gpdlib.scm
        export QA_GUILE_GPDLIB=~/qcd/src/qa/evff/gpdlib.scm
        ;;
    isaac)
        module load openmpi-uofa-gnu/1.8.1
        module load cuda/6.0
        module load gcc/4.7.2-rdt
        ;;
    phoenix)
		export WORK=/data/cssm/achambers
        module load OpenMPI/1.8.8-GNU-4.9.3-2.25
        module load CUDA/6.5.14
        module load ncurses/6.0-GNU-4.9.3-2.25
        module load Autotools/20150215-GNU-4.9.3-2.25
        ;;
    raijin)
        module unload intel-fc
        module unload intel-cc
        module load openmpi/1.6.5
        module load gcc/5.2.0
        ;;
    galaxy)
        module switch PrgEnv-cray PrgEnv-gnu
	module switch gcc/4.8.2 gcc/4.9.2
	;;
    hlrn)
	module switch PrgEnv-cray PrgEnv-gnu
	;;
esac
