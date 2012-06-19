#
#   bash_completion - programmable completion functions for bash 3.x
#             (backwards compatible with bash 2.05b)
#
#   Copyright © 2006-2008, Ian Macdonald <ian@caliban.org>
#             © 2009, Bash Completion Maintainers
#                     <bash-completion-devel@lists.alioth.debian.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#   The latest version of this software can be obtained here:
#
#   http://bash-completion.alioth.debian.org/
#
#   RELEASE: 1.1

if [[ $- == *v* ]]; then
    BASH_COMPLETION_ORIGINAL_V_VALUE="-v"
else
    BASH_COMPLETION_ORIGINAL_V_VALUE="+v"
fi

if [[ -n $BASH_COMPLETION_DEBUG ]]; then
    set -v
else
    set +v
fi

# Alter the following to reflect the location of this file.
#
[ -n "$BASH_COMPLETION" ] || BASH_COMPLETION=/etc/bash_completion
[ -n "$BASH_COMPLETION_DIR" ] || BASH_COMPLETION_DIR=/etc/bash_completion.d
[ -n "$BASH_COMPLETION_COMPAT_DIR" ] || BASH_COMPLETION_COMPAT_DIR=/etc/bash_completion.d
readonly BASH_COMPLETION BASH_COMPLETION_DIR BASH_COMPLETION_COMPAT_DIR

# Set a couple of useful vars
#
UNAME=$( uname -s )
# strip OS type and version under Cygwin (e.g. CYGWIN_NT-5.1 => Cygwin)
UNAME=${UNAME/CYGWIN_*/Cygwin}

case ${UNAME} in
    Linux|GNU|GNU/*) USERLAND=GNU ;;
    *) USERLAND=${UNAME} ;;
esac

# features supported by bash 2.05 and higher
if [ ${BASH_VERSINFO[0]} -eq 2 ] && [[ ${BASH_VERSINFO[1]} > 04 ]] ||
    [ ${BASH_VERSINFO[0]} -gt 2 ]; then
    declare -r bash205=$BASH_VERSION 2>/dev/null || :
    default="-o default"
    dirnames="-o dirnames"
    filenames="-o filenames"
    compopt=:
fi
# features supported by bash 2.05b and higher
if [ ${BASH_VERSINFO[0]} -eq 2 ] && [[ ${BASH_VERSINFO[1]} = "05b" ]] ||
    [ ${BASH_VERSINFO[0]} -gt 2 ]; then
    declare -r bash205b=$BASH_VERSION 2>/dev/null || :
    nospace="-o nospace"
fi
# features supported by bash 3.0 and higher
if [ ${BASH_VERSINFO[0]} -gt 2 ]; then
    declare -r bash3=$BASH_VERSION 2>/dev/null || :
    bashdefault="-o bashdefault"
    plusdirs="-o plusdirs"
fi
# features supported by bash 4.0 and higher
if [ ${BASH_VERSINFO[0]} -gt 3 ]; then
    declare -r bash4=$BASH_VERSION 2>/dev/null || :
    compopt=compopt
fi

# Turn on extended globbing and programmable completion
shopt -s extglob progcomp

# A lot of the following one-liners were taken directly from the
# completion examples provided with the bash 2.04 source distribution

# Make directory commands see only directories
complete -d pushd

# The following section lists completions that are redefined later
# Do NOT break these over multiple lines.
#
# START exclude -- do NOT remove this line
# bzcmp, bzdiff, bz*grep, bzless, bzmore intentionally not here, see Debian: #455510
complete -f -X '!*.?(t)bz?(2)' bunzip2 bzcat
complete -f -X '!*.@(zip|ZIP|jar|JAR|exe|EXE|pk3|war|wsz|ear|zargo|xpi|sxw|ott|od[fgpst]|epub)' unzip zipinfo
complete -f -X '*.Z' compress znew
# zcmp, zdiff, z*grep, zless, zmore intentionally not here, see Debian: #455510
complete -f -X '!*.@(Z|gz|tgz|Gz|dz)' gunzip zcat
complete -f -X '!*.Z' uncompress
# lzcmp, lzdiff intentionally not here, see Debian: #455510
complete -f -X '!*.lzma' lzcat lzegrep lzfgrep lzgrep lzless lzmore unlzma
complete -f -X '!*.@(xz|lzma)' unxz xzcat
complete -f -X '!*.@(gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX)' ee
complete -f -X '!*.@(gif|jp?(e)g|tif?(f)|png|p[bgp]m|bmp|x[bp]m|rle|rgb|pcx|fits|pm|GIF|JPG|JP?(E)G|TIF?(F)|PNG|P[BGP]M|BMP|X[BP]M|RLE|RGB|PCX|FITS|PM)' xv qiv
complete -f -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv kghostview
complete -f -X '!*.@(dvi|DVI)?(.@(gz|Z|bz2))' xdvi
complete -f -X '!*.@(dvi|DVI)?(.@(gz|Z|bz2))' kdvi
complete -f -X '!*.@(dvi|DVI)' dvips dviselect dvitype dvipdf advi dvipdfm dvipdfmx
complete -f -X '!*.@(pdf|PDF)' acroread gpdf xpdf
complete -f -X '!*.@(?(e)ps|?(E)PS|pdf|PDF)' kpdf
complete -f -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF|dvi|DVI)?(.gz|.GZ|.bz2|.BZ2)|cb[rz]|CB[RZ]|djv?(u)|DJV?(U)|dvi|DVI|gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX)' evince
complete -f -X '!*.@(?(e|x)ps|?(E|X)PS|pdf|PDF|dvi|DVI|cb[rz]|CB[RZ]|djv?(u)|DJV?(U)|dvi|DVI|gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX|epub|EPUB|odt|ODT|fb|FB|mobi|MOBI|g3|G3|chm|CHM)?(.?(gz|GZ|bz2|BZ2))' okular
complete -f -X '!*.@(?(e)ps|?(E)PS|pdf|PDF)' ps2pdf ps2pdf12 ps2pdf13 ps2pdf14 ps2pdfwr
complete -f -X '!*.texi*' makeinfo texi2html
complete -f -X '!*.@(?(la)tex|?(LA)TEX|texi|TEXI|dtx|DTX|ins|INS)' tex latex slitex jadetex pdfjadetex pdftex pdflatex texi2dvi
complete -f -X '!*.@(mp3|MP3)' mpg123 mpg321 madplay
complete -f -X '!*@(.@(mp?(e)g|MP?(E)G|wma|avi|AVI|asf|vob|VOB|bin|dat|divx|DIVX|vcd|ps|pes|fli|flv|FLV|viv|rm|ram|yuv|mov|MOV|qt|QT|wmv|mp[234]|MP[234]|m4[pv]|M4[PV]|mkv|MKV|og[gmv]|OG[GMV]|wav|WAV|asx|ASX|mng|MNG|srt|m[eo]d|M[EO]D|s[3t]m|S[3T]M|it|IT|xm|XM)|+([0-9]).@(vdr|VDR))' xine aaxine fbxine kaffeine
complete -f -X '!*.@(avi|asf|wmv)' aviplay
complete -f -X '!*.@(rm?(j)|ra?(m)|smi?(l))' realplay
complete -f -X '!*.@(mpg|mpeg|avi|mov|qt)' xanim
complete -f -X '!*.@(ogg|OGG|m3u|flac|spx)' ogg123
complete -f -X '!*.@(mp3|MP3|ogg|OGG|pls|m3u)' gqmpeg freeamp
complete -f -X '!*.fig' xfig
complete -f -X '!*.@(mid?(i)|MID?(I)|cmf|CMF)' playmidi
complete -f -X '!*.@(mid?(i)|MID?(I)|rmi|RMI|rcp|RCP|[gr]36|[GR]36|g18|G18|mod|MOD|xm|XM|it|IT|x3m|X3M|s[3t]m|S[3T]M|kar|KAR)' timidity
complete -f -X '!*.@(m[eo]d|M[EO]D|s[3t]m|S[3T]M|xm|XM|it|IT)' modplugplay
complete -f -X '*.@(o|so|so.!(conf)|a|rpm|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MPG|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)' vi vim gvim rvim view rview rgvim rgview gview
complete -f -X '*.@(o|so|so.!(conf)|a|rpm|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MPG|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)' emacs
complete -f -X '!*.@(exe|EXE|com|COM|scr|SCR|exe.so)' wine
complete -f -X '!*.@(zip|ZIP|z|Z|gz|GZ|tgz|TGZ)' bzme
complete -f -X '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL]))' netscape mozilla lynx opera galeon curl dillo elinks amaya
complete -f -X '!*.@(sxw|stw|sxg|sgl|doc?([mx])|dot?([mx])|rtf|txt|htm|html|odt|ott|odm)' oowriter
complete -f -X '!*.@(sxi|sti|pps?(x)|ppt?([mx])|pot?([mx])|odp|otp)' ooimpress
complete -f -X '!*.@(sxc|stc|xls?([bmx])|xlw|xlt?([mx])|[ct]sv|ods|ots)' oocalc
complete -f -X '!*.@(sxd|std|sda|sdd|odg|otg)' oodraw
complete -f -X '!*.@(sxm|smf|mml|odf)' oomath
complete -f -X '!*.odb' oobase
complete -f -X '!*.rpm' rpm2cpio
complete -f -X '!*.sqlite' sqlite3
complete -f -X '!*.aux' bibtex
complete -f -X '!*.po' poedit gtranslator kbabel lokalize
complete -f -X '!*.@([Pp][Rr][Gg]|[Cc][Ll][Pp])' harbour gharbour hbpp
complete -f -X '!*.[Hh][Rr][Bb]' hbrun
complete -f -X '!*.ly' lilypond ly2dvi
# FINISH exclude -- do not remove this line

# start of section containing compspecs that can be handled within bash

# user commands see only users
complete -u su passwd write chfn groups slay w sux

# bg completes with stopped jobs
complete -A stopped -P '"%' -S '"' bg

# other job commands
complete -j -P '"%' -S '"' fg jobs disown

# readonly and unset complete with shell variables
complete -v readonly unset

# set completes with set options
complete -A setopt set

# shopt completes with shopt options
complete -A shopt shopt

# helptopics
complete -A helptopic help

# unalias completes with aliases
complete -a unalias

# bind completes with readline bindings (make this more intelligent)
complete -A binding bind

# type and which complete on commands
complete -c command type which

# builtin completes on builtins
complete -b builtin

# start of section containing completion functions called by other functions

# This function checks whether we have a given program on the system.
# No need for bulky functions in memory if we don't.
#
have()
{
    unset -v have
    PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin type $1 &>/dev/null &&
    have="yes"
}

# use GNU sed if we have it, since its extensions are still used in our code
#
[ $USERLAND != GNU ] && have gsed && alias sed=gsed

# This function checks whether a given readline variable
# is `on'.
#
_rl_enabled()
{
    [[ "$( bind -v )" = *$1+([[:space:]])on* ]]
}

# This function shell-quotes the argument
quote()
{
    echo \'${1//\'/\'\\\'\'}\' #'# Help vim syntax highlighting
}

# This function quotes the argument in a way so that readline dequoting
# results in the original argument
quote_readline()
{
    if [ -n "$bash4" ] ; then
        # This function isn't really necessary on bash 4
        # See: http://lists.gnu.org/archive/html/bug-bash/2009-03/msg00155.html
        echo "${1}"
        return
    fi
    local t="${1//\\/\\\\}"
    echo \'${t//\'/\'\\\'\'}\' #'# Help vim syntax highlighting
}

# This function shell-dequotes the argument
dequote()
{
    eval echo "$1" 2> /dev/null
}

# Get the word to complete.
# This is nicer than ${COMP_WORDS[$COMP_CWORD]}, since it handles cases
# where the user is completing in the middle of a word.
# (For example, if the line is "ls foobar",
# and the cursor is here -------->   ^
# it will complete just "foo", not "foobar", which is what the user wants.)
# @param $1 string  (optional) Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path.
#     NOTE: This parameter only applies to bash-4.

_get_cword()
{
    if [ -n "$bash4" ] ; then
        __get_cword4 "$@"
    else
        __get_cword3
    fi
} # _get_cword()


# Get the word to complete on bash-3, where words are not broken by
# COMP_WORDBREAKS characters and the COMP_CWORD variables look like this, for
# example:
#
#     $ a b:c<TAB>
#     COMP_CWORD: 1
#     COMP_CWORDS:
#     0: a
#     1: b:c
#
# See also:
# _get_cword, main routine
# __get_cword4, bash-4 variant
#
__get_cword3()
{
    if [[ "${#COMP_WORDS[COMP_CWORD]}" -eq 0 ]] || [[ "$COMP_POINT" == "${#COMP_LINE}" ]]; then
        printf "%s" "${COMP_WORDS[COMP_CWORD]}"
    else
        local i
        local cur="$COMP_LINE"
        local index="$COMP_POINT"
        for (( i = 0; i <= COMP_CWORD; ++i )); do
            while [[
                # Current COMP_WORD fits in $cur?
                "${#cur}" -ge ${#COMP_WORDS[i]} &&
                # $cur doesn't match COMP_WORD?
                "${cur:0:${#COMP_WORDS[i]}}" != "${COMP_WORDS[i]}"
                ]]; do
                # Strip first character
                cur="${cur:1}"
                # Decrease cursor position
                index="$(( index - 1 ))"
            done

            # Does found COMP_WORD matches COMP_CWORD?
            if [[ "$i" -lt "$COMP_CWORD" ]]; then
                # No, COMP_CWORD lies further;
                local old_size="${#cur}"
                cur="${cur#${COMP_WORDS[i]}}"
                local new_size="${#cur}"
                index="$(( index - old_size + new_size ))"
            fi
        done

        if [[ "${COMP_WORDS[COMP_CWORD]:0:${#cur}}" != "$cur" ]]; then
            # We messed up! At least return the whole word so things
            # keep working
            printf "%s" "${COMP_WORDS[COMP_CWORD]}"
        else
            printf "%s" "${cur:0:$index}"
        fi
    fi
} # __get_cword3()


# Get the word to complete on bash-4, where words are splitted by
# COMP_WORDBREAKS characters (default is " \t\n\"'><=;|&(:") and the COMP_CWORD
# variables look like this, for example:
#
#     $ a b:c<TAB>
#     COMP_CWORD: 3
#     COMP_CWORDS:
#     0: a
#     1: b
#     2: :
#     3: c
#
# @oaram $1 string
# $1 string  (optional) Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path.
# See also:
# _get_cword, main routine
# __get_cword3, bash-3 variant
#
__get_cword4()
{
    local i
    local LC_CTYPE=C
    local WORDBREAKS=$COMP_WORDBREAKS
    # Strip single quote (') and double quote (") from WORDBREAKS to
    # workaround a bug in bash-4.0, where quoted words are split
    # unintended, see:
    # http://www.mail-archive.com/bug-bash@gnu.org/msg06095.html
    # This fixes simple quoting (e.g. $ a "b<TAB> returns "b instead of b)
    # but still fails quoted spaces (e.g. $ a "b c<TAB> returns c instead
    # of "b c).
    WORDBREAKS=${WORDBREAKS//\"/}
    WORDBREAKS=${WORDBREAKS//\'/}
    if [ -n "$1" ]; then
        for (( i=0; i<${#1}; ++i )); do
            local char=${1:$i:1}
            WORDBREAKS=${WORDBREAKS//$char/}
        done
    fi
    local cur=${COMP_LINE:0:$COMP_POINT}
    local tmp=$cur
    local word_start=`expr "$tmp" : '.*['"$WORDBREAKS"']'`
    while [ "$word_start" -ge 2 ]; do
        # Get character before $word_start
        local char=${cur:$(( $word_start - 2 )):1}
        # If the WORDBREAK character isn't escaped, exit loop
        if [ "$char" != "\\" ]; then
            break
        fi
        # The WORDBREAK character is escaped;
        # Recalculate $word_start
        tmp=${COMP_LINE:0:$(( $word_start - 2 ))}
        word_start=`expr "$tmp" : '.*['"$WORDBREAKS"']'`
    done

    cur=${cur:$word_start}
    printf "%s" "$cur"
} # __get_cword4()


# This function performs file and directory completion. It's better than
# simply using 'compgen -f', because it honours spaces in filenames.
# If passed -d, it completes only on directories. If passed anything else,
# it's assumed to be a file glob to complete on.
#
_filedir()
{
    local IFS=$'\t\n' xspec

    _expand || return 0

    local -a toks
    local tmp

    # TODO: I've removed a "[ -n $tmp ] &&" before `echo $tmp',
    #       and everything works again. If this bug
    #       suddenly appears again (i.e. "cd /b<TAB>"
    #       becomes "cd /"), remember to check for
    #       other similar conditionals (here and
    #       _filedir_xspec()). --David
    # NOTE: The comment above has been moved outside of the subshell below,
    #       because quotes-in-comments-in-a-subshell cause errors on
    #       bash-3.1.  See also:
    #       http://www.mail-archive.com/bug-bash@gnu.org/msg01667.html
    toks=( ${toks[@]-} $(
    compgen -d -- "$(quote_readline "$cur")" | {
    while read -r tmp; do
        echo $tmp
    done
}
))

if [[ "$1" != -d ]]; then
    xspec=${1:+"!*.$1"}
    toks=( ${toks[@]-} $(
    compgen -f -X "$xspec" -- "$(quote_readline "$cur")" | {
    while read -r tmp; do
        [ -n $tmp ] && echo $tmp
    done
}
))
    fi

    COMPREPLY=( "${COMPREPLY[@]}" "${toks[@]}" )
}

# This function splits $cur=--foo=bar into $prev=--foo, $cur=bar, making it
# easier to support both "--foo bar" and "--foo=bar" style completions.
# Returns 0 if current option was split, 1 otherwise.
#
_split_longopt()
{
    if [[ "$cur" == --?*=* ]]; then
        # Cut also backslash before '=' in case it ended up there
        # for some reason.
        prev="${cur%%?(\\)=*}"
        cur="${cur#*=}"
        return 0
    fi

    return 1
}

# This function tries to parse the output of $command --help
#
_parse_help() {
    local cmd
    cmd=$1
    $cmd --help | \
    grep -- "^[[:space:]]*-" | \
    tr "," " " | \
    awk '{print $1; if ($2 ~ /-.*/) { print $2 } }' | \
    sed -e "s:=.*::g"
}

# This function completes on signal names
#
_signals()
{
    local i

    # standard signal completion is rather braindead, so we need
    # to hack around to get what we want here, which is to
    # complete on a dash, followed by the signal name minus
    # the SIG prefix
    COMPREPLY=( $( compgen -A signal SIG${cur#-} ))
    for (( i=0; i < ${#COMPREPLY[@]}; i++ )); do
        COMPREPLY[i]=-${COMPREPLY[i]#SIG}
    done
}

# This function completes on configured network interfaces
#
_configured_interfaces()
{
    if [ -f /etc/debian_version ]; then
        # Debian system
        COMPREPLY=( $( compgen -W "$( sed -ne 's|^iface \([^ ]\+\).*$|\1|p' \
            /etc/network/interfaces )" -- "$cur" ) )
    elif [ -f /etc/SuSE-release ]; then
        # SuSE system
        COMPREPLY=( $( compgen -W "$( command ls \
            /etc/sysconfig/network/ifcfg-* | \
            sed -ne 's|.*ifcfg-\(.*\)|\1|p' )" -- "$cur" ) )
    elif [ -f /etc/pld-release ]; then
        # PLD Linux
        COMPREPLY=( $( compgen -W "$( command ls -B \
            /etc/sysconfig/interfaces | \
            sed -ne 's|.*ifcfg-\(.*\)|\1|p' )" -- "$cur" ) )
    else
        # Assume Red Hat
        COMPREPLY=( $( compgen -W "$( command ls \
            /etc/sysconfig/network-scripts/ifcfg-* | \
            sed -ne 's|.*ifcfg-\(.*\)|\1|p' )" -- "$cur" ) )
    fi
}

# This function completes on available kernels
#
_kernel_versions()
{
    COMPREPLY=( $( compgen -W '$( command ls /lib/modules )' -- "$cur" ) )
}

# This function completes on all available network interfaces
# -a: restrict to active interfaces only
# -w: restrict to wireless interfaces only
#
_available_interfaces()
{
    local cmd

    if [ "${1:-}" = -w ]; then
        cmd="iwconfig"
    elif [ "${1:-}" = -a ]; then
        cmd="ifconfig"
    else
        cmd="ifconfig -a"
    fi

    COMPREPLY=( $( eval $cmd 2>/dev/null | \
        awk '/^[^[:space:]]/ { print $1 }' ) )
    COMPREPLY=( $( compgen -W '${COMPREPLY[@]/%[[:punct:]]/}' -- "$cur" ) )
}

# This function expands tildes in pathnames
#
_expand()
{
    # FIXME: Why was this here?
    #[ "$cur" != "${cur%\\}" ] && cur="$cur\\"

    # Expand ~username type directory specifications.  We want to expand
    # ~foo/... to /home/foo/... to avoid problems when $cur starting with
    # a tilde is fed to commands and ending up quoted instead of expanded.

    if [[ "$cur" == \~*/* ]]; then
        eval cur=$cur
    elif [[ "$cur" == \~* ]]; then
        cur=${cur#\~}
        COMPREPLY=( $( compgen -P '~' -u "$cur" ) )
        [ ${#COMPREPLY[@]} -eq 1 ] && eval COMPREPLY[0]=${COMPREPLY[0]}
        return ${#COMPREPLY[@]}
    fi
}

# This function completes on process IDs.
# AIX and Solaris ps prefers X/Open syntax.
[ $UNAME = SunOS -o $UNAME = AIX ] &&
_pids()
{
    COMPREPLY=( $( compgen -W '$( command ps -efo pid | sed 1d )' -- "$cur" ))
} ||
_pids()
{
    COMPREPLY=( $( compgen -W '$( command ps axo pid= )' -- "$cur" ) )
}

# This function completes on process group IDs.
# AIX and SunOS prefer X/Open, all else should be BSD.
[ $UNAME = SunOS -o $UNAME = AIX ] &&
_pgids()
{
    COMPREPLY=( $( compgen -W '$( command ps -efo pgid | sed 1d )' -- "$cur" ))
} ||
_pgids()
{
    COMPREPLY=( $( compgen -W '$( command ps axo pgid= )' -- "$cur" ))
}

# This function completes on process names.
# AIX and SunOS prefer X/Open, all else should be BSD.
[ $UNAME = SunOS -o $UNAME = AIX ] &&
_pnames()
{
    COMPREPLY=( $( compgen -W '$( command ps -efo comm | \
    sed -e 1d -e "s:.*/::" -e "s/^-//" \
    -e "s/^<defunct>$//")' \
    -- "$cur" ) )
} ||
_pnames()
{
    # FIXME: completes "[kblockd/0]" to "0". Previously it was completed
    # to "kblockd" which isn't correct either. "kblockd/0" would be
    # arguably most correct, but killall from psmisc 22 treats arguments
    # containing "/" specially unless -r is given so that wouldn't quite
    # work either. Perhaps it'd be best to not complete these to anything
    # for now.
    # Not using "ps axo comm" because under some Linux kernels, it
    # truncates command names (see e.g. http://bugs.debian.org/497540#19)
    COMPREPLY=( $( compgen -W '$( command ps axo command= | \
    sed -e "s/ .*//; s:.*/::; s/:$//;" \
    -e "s/^[[(-]//; s/[])]$//" \
    -e "s/^<defunct>$//")' \
    -- "$cur" ) )
}

# This function completes on user IDs
#
_uids()
{
    if type getent &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( getent passwd | cut -d: -f3 )' -- "$cur" ) )
    elif type perl &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( perl -e '"'"'while (($uid) = (getpwent)[2]) { print $uid . "\n" }'"'"' )' -- "$cur" ) )
    else
        # make do with /etc/passwd
        COMPREPLY=( $( compgen -W '$( cut -d: -f3 /etc/passwd )' -- "$cur" ) )
    fi
}

# This function completes on group IDs
#
_gids()
{
    if type getent &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( getent group | cut -d: -f3 )' \
            -- "$cur" ) )
    elif type perl &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( perl -e '"'"'while (($gid) = (getgrent)[2]) { print $gid . "\n" }'"'"' )' -- "$cur" ) )
    else
        # make do with /etc/group
        COMPREPLY=( $( compgen -W '$( cut -d: -f3 /etc/group )' -- "$cur" ) )
    fi
}

# This function completes on services
#
_services()
{
    local sysvdir famdir
    [ -d /etc/rc.d/init.d ] && sysvdir=/etc/rc.d/init.d || sysvdir=/etc/init.d
    famdir=/etc/xinetd.d
    COMPREPLY=( $( builtin echo $sysvdir/!(*.rpm@(orig|new|save)|*~|functions)) )

    if [ -d $famdir ]; then
        COMPREPLY=( "${COMPREPLY[@]}" $( builtin echo $famdir/!(*.rpm@(orig|new|save)|*~)) )
    fi

    COMPREPLY=( $( compgen -W '${COMPREPLY[@]#@($sysvdir|$famdir)/}' -- "$cur" ) )
}

# This function completes on modules
#
_modules()
{
    local modpath
    modpath=/lib/modules/$1
    COMPREPLY=( $( compgen -W "$( command ls -R $modpath | \
        sed -ne 's/^\(.*\)\.k\?o\(\|.gz\)$/\1/p' )" -- "$cur" ) )
}

# This function completes on installed modules
#
_installed_modules()
{
    COMPREPLY=( $( compgen -W "$( PATH="$PATH:/sbin" lsmod | \
        awk '{if (NR != 1) print $1}' )" -- "$1" ) )
}

# This function completes on user:group format
#
_usergroup()
{
    local IFS=$'\n'
    cur=${cur//\\\\ / }
    if [[ $cur = *@(\\:|.)* ]] && [ -n "$bash205" ]; then
        user=${cur%%*([^:.])}
        COMPREPLY=( $(compgen -P ${user/\\\\} -g -- ${cur##*[.:]}) )
    elif [[ $cur = *:* ]] && [ -n "$bash205" ]; then
        COMPREPLY=( $( compgen -g -- ${cur##*[.:]} ) )
    else
        COMPREPLY=( $( compgen -S : -u -- "$cur" ) )
    fi
}

# This function completes on valid shells
#
_shells()
{
    COMPREPLY=( "${COMPREPLY[@]}" $( compgen -W '$( grep "^[[:space:]]*/" \
    /etc/shells 2>/dev/null )' -- "$cur" ) )
}

# Get real command.
# - arg: $1  Command
# - stdout:  Filename of command in PATH with possible symbolic links resolved.
#            Empty string if command not found.
# - return:  True (0) if command found, False (> 0) if not.
_realcommand() {
    type -P "$1" > /dev/null && {
    if type -p realpath > /dev/null; then
        realpath "$(type -P "$1")"
    elif type -p readlink > /dev/null; then
        readlink -f "$(type -P "$1")"
    else
        type -P "$1"
    fi
}
}


# this function count the number of mandatory args
#
_count_args()
{
    args=1
    for (( i=1; i < COMP_CWORD; i++ )); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            args=$(($args+1))
        fi
    done
}

# This function completes on PCI IDs
#
_pci_ids()
{
    COMPREPLY=( ${COMPREPLY[@]:-} $( compgen -W \
    "$( PATH="$PATH:/sbin" lspci -n | awk '{print $3}')" -- "$cur" ) )
}

# This function completes on USB IDs
#
_usb_ids()
{
    COMPREPLY=( ${COMPREPLY[@]:-} $( compgen -W \
    "$( PATH="$PATH:/sbin" lsusb | awk '{print $6}' )" -- "$cur" ) )
}

# start of section containing completion functions for external programs

# a little help for FreeBSD ports users
[ $UNAME = FreeBSD ] && complete -W 'index search fetch fetch-list \
extract patch configure build install reinstall \
deinstall clean clean-depends kernel buildworld' make

# This completes on a list of all available service scripts for the
# 'service' command and/or the SysV init.d directory, followed by
# that script's available commands
#
{ have service || [ -d /etc/init.d/ ]; } &&
    _service()
    {
        local cur prev sysvdir

        COMPREPLY=()
        prev=${COMP_WORDS[COMP_CWORD-1]}
        cur=`_get_cword`

        # don't complete for things like killall, ssh and mysql if it's
        # the standalone command, rather than the init script
        [[ ${COMP_WORDS[0]} != @(*init.d/!(functions|~)|service) ]] && return 0

        # don't complete past 2nd token
        [ $COMP_CWORD -gt 2 ] && return 0

        [ -d /etc/rc.d/init.d ] && sysvdir=/etc/rc.d/init.d \
        || sysvdir=/etc/init.d

        if [[ $COMP_CWORD -eq 1 ]] && [[ $prev == "service" ]]; then
            _services
        else
            COMPREPLY=( $( compgen -W '`sed -ne "y/|/ /; \
            s/^.*\(U\|msg_u\)sage.*{\(.*\)}.*$/\1/p" \
            $sysvdir/${prev##*/} 2>/dev/null`' -- "$cur" ) )
        fi

        return 0
    } &&
    complete -F _service service
    [ -d /etc/init.d/ ] && complete -F _service $default \
    $(for i in /etc/init.d/*; do echo ${i##*/}; done)

    # chown(1) completion
    #
    _chown()
    {
        local cur prev split=false
        cur=`_get_cword`
        prev=${COMP_WORDS[COMP_CWORD-1]}

        _split_longopt && split=true

        case "$prev" in
            --from)
                _usergroup
                return 0
                ;;
            --reference)
                _filedir
                return 0
                ;;
        esac

        $split && return 0

        # options completion
        if [[ "$cur" == -* ]]; then
            COMPREPLY=( $( compgen -W '-c -h -f -R -v --changes \
            --dereference --no-dereference --from --silent --quiet \
            --reference --recursive --verbose --help --version' -- "$cur" ) )
        else
            _count_args

            case $args in
                1)
                    _usergroup
                    ;;
                *)
                    _filedir
                    ;;
            esac
        fi
    }
    complete -F _chown $filenames chown

    # chgrp(1) completion
    #
    _chgrp()
    {
        local cur prev split=false

        COMPREPLY=()
        cur=`_get_cword`
        cur=${cur//\\\\/}
        prev=${COMP_WORDS[COMP_CWORD-1]}

        _split_longopt && split=true

        if [[ "$prev" == --reference ]]; then
            _filedir
            return 0
        fi

        $split && return 0

        # options completion
        if [[ "$cur" == -* ]]; then
            COMPREPLY=( $( compgen -W '-c -h -f -R -v --changes \
            --dereference --no-dereference --silent --quiet \
            --reference --recursive --verbose --help --version' -- "$cur" ) )
            return 0
        fi

        # first parameter on line or first since an option?
        if [ $COMP_CWORD -eq 1 ] && [[ "$cur" != -* ]] || \
            [[ "$prev" == -* ]] && [ -n "$bash205" ]; then
            local IFS=$'\n'
            COMPREPLY=( $( compgen -g "$cur" 2>/dev/null ) )
        else
            _filedir || return 0
        fi

        return 0
    }
    complete -F _chgrp $filenames chgrp

    # umount(8) completion. This relies on the mount point being the third
    # space-delimited field in the output of mount(8)
    #
    _umount()
    {
        local cur IFS=$'\n'

        COMPREPLY=()
        cur=`_get_cword`

        COMPREPLY=( $( compgen -W '$( mount | cut -d" " -f 3 )' -- "$cur" ) )

        return 0
    }
    complete -F _umount $dirnames umount

    # mount(8) completion. This will pull a list of possible mounts out of
    # /etc/{,v}fstab, unless the word being completed contains a ':', which
    # would indicate the specification of an NFS server. In that case, we
    # query the server for a list of all available exports and complete on
    # that instead.
    #
    _mount()
    {
        local cur i sm host prev

        COMPREPLY=()
        cur=`_get_cword`
        [[ "$cur" == \\ ]] && cur="/"
        prev=${COMP_WORDS[COMP_CWORD-1]}

        for i in {,/usr}/{,s}bin/showmount; do [ -x $i ] && sm=$i && break; done

        if [ -n "$sm" ] && [[ "$cur" == *:* ]]; then
            COMPREPLY=( $( compgen -W "$( $sm -e ${cur%%:*} | sed 1d | \
                awk '{print $1}' )" -- "$cur" ) )
        elif [[ "$cur" == //* ]]; then
            host=${cur#//}
            host=${host%%/*}
            if [ -n "$host" ]; then
                COMPREPLY=( $( compgen -P "//$host" -W \
                    "$( smbclient -d 0 -NL $host 2>/dev/null |
                    sed -ne '/^['"$'\t '"']*Sharename/,/^$/p' |
                    sed -ne '3,$s|^[^A-Za-z]*\([^'"$'\t '"']*\).*$|/\1|p' )" \
                    -- "${cur#//$host}" ) )
            fi
        elif [ -r /etc/vfstab ]; then
            # Solaris
            COMPREPLY=( $( compgen -W "$( awk '! /^[ \t]*#/ {if ($3 ~ /\//) print $3}' /etc/vfstab )" -- "$cur" ) )
        elif [ ! -e /etc/fstab ]; then
            # probably Cygwin
            COMPREPLY=( $( compgen -W "$( mount | awk '! /^[ \t]*#/ {if ($3 ~ /\//) print $3}' )" -- "$cur" ) )
        else
            # probably Linux
            if [ $prev = -L ]; then
                COMPREPLY=( $( compgen -W '$(sed -ne "s/^[[:space:]]*LABEL=\([^[:space:]]*\).*/\1/p" /etc/fstab )' -- "$cur" ) )
            elif [ $prev = -U ]; then
                COMPREPLY=( $( compgen -W '$(sed -ne "s/^[[:space:]]*UUID=\([^[:space:]]*\).*/\1/p" /etc/fstab )' -- "$cur" ) )
            else
                COMPREPLY=( $( compgen -W "$( awk '! /^[ \t]*#/ {if ($2 ~ /\//) print $2}' /etc/fstab )" -- "$cur" ) )
            fi
        fi

        return 0
    }
    complete -F _mount $default $dirnames mount

    # Linux rmmod(8) completion. This completes on a list of all currently
    # installed kernel modules.
    #
    have rmmod && {
    _rmmod()
    {
        local cur

        COMPREPLY=()
        cur=`_get_cword`

        _installed_modules "$cur"
        return 0
    }
    complete -F _rmmod rmmod

    # Linux insmod(8), modprobe(8) and modinfo(8) completion. This completes on a
    # list of all available modules for the version of the kernel currently
    # running.
    #
    _insmod()
    {
        local cur prev modpath

        COMPREPLY=()
        cur=`_get_cword`
        prev=${COMP_WORDS[COMP_CWORD-1]}

        # behave like lsmod for modprobe -r
        if [ $1 = "modprobe" ] &&
            [ "${COMP_WORDS[1]}" = "-r" ]; then
            _installed_modules "$cur"
            return 0
        fi

        # do filename completion if we're giving a path to a module
        if [[ "$cur" == */* ]]; then
            _filedir '@(?(k)o?(.gz))'
            return 0
        fi

        if [ $COMP_CWORD -gt 1 ] &&
            [[ "${COMP_WORDS[COMP_CWORD-1]}" != -* ]]; then
            # do module parameter completion
            COMPREPLY=( $( compgen -W "$( /sbin/modinfo -p ${COMP_WORDS[1]} | \
                cut -d: -f1 )" -- "$cur" ) )
        else
            _modules $(uname -r)
        fi

        return 0
    }
    complete -F _insmod $filenames insmod modprobe modinfo
}

# renice(8) completion
#
_renice()
{
    local command cur curopt i

    COMPREPLY=()
    cur=`_get_cword`
    command=$1

    i=0
    # walk back through command line and find last option
    while [ $i -le $COMP_CWORD -a ${#COMPREPLY[@]} -eq 0 ]; do
        curopt=${COMP_WORDS[COMP_CWORD-$i]}
        case "$curopt" in
            -u)
                COMPREPLY=( $( compgen -u -- "$cur" ) )
                ;;
            -g)
                _pgids
                ;;
            -p|$command)
                _pids
                ;;
        esac
        i=$(( ++i ))
    done
}
complete -F _renice renice

# kill(1) completion
#
_kill()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [ $COMP_CWORD -eq 1 ] && [[ "$cur" == -* ]]; then
        # return list of available signals
        _signals
    else
        # return list of available PIDs
        _pids
    fi
}
complete -F _kill kill

# killall(1) (Linux and FreeBSD) and pkill(1) completion.
#
[ $UNAME = Linux -o $UNAME = FreeBSD ] || have pkill &&
_killall()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [ $COMP_CWORD -eq 1 ] && [[ "$cur" == -* ]]; then
        _signals
    else
        _pnames
    fi

    return 0
}
[ $UNAME = Linux -o $UNAME = FreeBSD ] && complete -F _killall killall
have pkill && complete -F _killall pkill

# pgrep(1) completion.
#
[ $UNAME = Linux ] || have pgrep &&
_pgrep()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    _pnames

    return 0
}
have pgrep && complete -F _pgrep pgrep

# Linux pidof(8) completion.
[ $UNAME = Linux ] && complete -F _pgrep pidof

# Red Hat & Debian GNU/Linux if{up,down} completion
#
[ $USERLAND = GNU ] && { have ifup || have ifdown; } &&
_ifupdown()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [ $COMP_CWORD -eq 1 ]; then
        _configured_interfaces
        COMPREPLY=( $(compgen -W '${COMPREPLY[@]}' -- "$cur") )
    fi

    return 0
} &&
complete -F _ifupdown ifup ifdown
[ $USERLAND = GNU ] && have ifstatus && complete -F _ifupdown ifstatus

# Linux ipsec(8) completion (for FreeS/WAN)
#
[ $UNAME = Linux ] && have ipsec &&
_ipsec()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`


    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $( compgen -W 'auto barf eroute klipsdebug look \
        manual pluto ranbits rsasigkey \
        setup showdefaults showhostkey spi \
        spigrp tncfg whack' -- "$cur" ) )
        return 0
    fi

    case ${COMP_WORDS[1]} in
        auto)
            COMPREPLY=( $( compgen -W '--asynchronous --up --add --delete \
                --replace --down --route --unroute \
                --ready --status --rereadsecrets' \
                -- "$cur" ) )
            ;;
        manual)
            COMPREPLY=( $( compgen -W '--up --down --route --unroute \
                --union' -- "$cur" ) )
            ;;
        ranbits)
            COMPREPLY=( $( compgen -W '--quick --continuous --bytes' \
                -- "$cur" ) )
            ;;
        setup)
            COMPREPLY=( $( compgen -W '--start --stop --restart' -- "$cur" ) )
            ;;
        *)
            ;;
    esac

    return 0
} &&
complete -F _ipsec ipsec

# This function provides simple user@host completion
#
_user_at_host() {
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [[ $cur == *@* ]]; then
        _known_hosts_real "$cur"
    else
        COMPREPLY=( $( compgen -u -- "$cur" ) )
    fi

    return 0
}
shopt -u hostcomplete && complete -F _user_at_host $nospace talk ytalk finger

# NOTE: Using this function as a helper function is deprecated.  Use
#       `_known_hosts_real' instead.
_known_hosts()
{
    local options
    COMPREPLY=()

    # NOTE: Using `_known_hosts' as a helper function and passing options
    #       to `_known_hosts' is deprecated: Use `_known_hosts_real' instead.
    [ "$1" = -a ] || [ "$2" = -a ] && options=-a
    [ "$1" = -c ] || [ "$2" = -c ] && options="$options -c"
    _known_hosts_real $options "$(_get_cword)"
}

# Helper function for completing _known_hosts.
# This function performs host completion based on ssh's known_hosts files.
# Also hosts from HOSTFILE (compgen -A hostname) are added, unless
# COMP_KNOWN_HOSTS_WITH_HOSTFILE is set to an empty value.
# Usage: _known_hosts_real [OPTIONS] CWORD
# Options:  -a             Use aliases
#           -c             Use `:' suffix
#           -F configfile  Use `configfile' for configuration settings
#           -p PREFIX      Use PREFIX
# Return: Completions, starting with CWORD, are added to COMPREPLY[]
_known_hosts_real()
{
    local configfile flag prefix
    local cur curd awkcur user suffix aliases hosts i host
    local -a kh khd config

    local OPTIND=1
    while getopts "acF:p:" flag "$@"; do
        case $flag in
            a) aliases='yes' ;;
            c) suffix=':' ;;
            F) configfile=$OPTARG ;;
            p) prefix=$OPTARG ;;
        esac
    done
    [ $# -lt $OPTIND ] && echo "error: $FUNCNAME: missing mandatory argument CWORD"
    cur=${!OPTIND}; let "OPTIND += 1"
    [ $# -ge $OPTIND ] && echo "error: $FUNCNAME("$@"): unprocessed arguments:"\
    $(while [ $# -ge $OPTIND ]; do echo ${!OPTIND}; shift; done)

    [[ $cur == *@* ]] && user=${cur%@*}@ && cur=${cur#*@}
    kh=()

    # ssh config files
    if [ -n "$configfile" ]; then
        [ -r "$configfile" ] &&
        config=( "${config[@]}" "$configfile" )
    else
        [ -r /etc/ssh/ssh_config ] &&
        config=( "${config[@]}" "/etc/ssh/ssh_config" )
        [ -r "${HOME}/.ssh/config" ] &&
        config=( "${config[@]}" "${HOME}/.ssh/config" )
        [ -r "${HOME}/.ssh2/config" ] &&
        config=( "${config[@]}" "${HOME}/.ssh2/config" )
    fi

    # Known hosts files from configs
    if [ ${#config[@]} -gt 0 ]; then
        local OIFS=$IFS IFS=$'\n'
        local -a tmpkh
        # expand paths (if present) to global and user known hosts files
        # TODO(?): try to make known hosts files with more than one consecutive
        #          spaces in their name work (watch out for ~ expansion
        #          breakage! Alioth#311595)
        tmpkh=( $( sed -ne 's/^[ \t]*\([Gg][Ll][Oo][Bb][Aa][Ll]\|[Uu][Ss][Ee][Rr]\)[Kk][Nn][Oo][Ww][Nn][Hh][Oo][Ss][Tt][Ss][Ff][Ii][Ll][Ee]['"$'\t '"']*\(.*\)$/\2/p' "${config[@]}" | sort -u ) )
        for i in "${tmpkh[@]//\"/}"; do
            i=$( eval echo "$i" ) # expand ~
            [ -r "$i" ] && kh=( "${kh[@]}" "$i" )
        done
        IFS=$OIFS
    fi

    # Global known_hosts files
    if [ -z "$configfile" ]; then
        [ -r /etc/ssh/ssh_known_hosts ] &&
        kh=( "${kh[@]}" /etc/ssh/ssh_known_hosts )
        [ -r /etc/ssh/ssh_known_hosts2 ] &&
        kh=( "${kh[@]}" /etc/ssh/ssh_known_hosts2 )
        [ -r /etc/known_hosts ] &&
        kh=( "${kh[@]}" /etc/known_hosts )
        [ -r /etc/known_hosts2 ] &&
        kh=( "${kh[@]}" /etc/known_hosts2 )
        [ -d /etc/ssh2/knownhosts ] &&
        khd=( "${khd[@]}" /etc/ssh2/knownhosts/*pub )
    fi

    # User known_hosts files
    if [ -z "$configfile" ]; then
        [ -r ~/.ssh/known_hosts ] &&
        kh=( "${kh[@]}" ~/.ssh/known_hosts )
        [ -r ~/.ssh/known_hosts2 ] &&
        kh=( "${kh[@]}" ~/.ssh/known_hosts2 )
        [ -d ~/.ssh2/hostkeys ] &&
        khd=( "${khd[@]}" ~/.ssh2/hostkeys/*pub )
    fi

    # If we have known_hosts files to use
    if [ ${#kh[@]} -gt 0 -o ${#khd[@]} -gt 0 -o -n "$configfile" ]; then
        # Escape slashes and dots in paths for awk
        awkcur=${cur//\//\\\/}
        awkcur=${awkcur//\./\\\.}
        curd=$awkcur

        if [[ "$awkcur" == [0-9]*.* ]]; then
            # Digits followed by a dot - just search for that
            awkcur="^$awkcur.*"
        elif [[ "$awkcur" == [0-9]* ]]; then
            # Digits followed by no dot - search for digits followed
            # by a dot
            awkcur="^$awkcur.*\."
        elif [ -z "$awkcur" ]; then
            # A blank - search for a dot or an alpha character
            awkcur="[a-z.]"
        else
            awkcur="^$awkcur"
        fi

        if [ ${#kh[@]} -gt 0 ]; then
            # FS needs to look for a comma separated list
            COMPREPLY=( $( awk 'BEGIN {FS=","}
            /^\s*[^|\#]/ {for (i=1; i<=2; ++i) { \
            gsub(" .*$", "", $i); \
            gsub("[\\[\\]]", "", $i); \
            gsub(":[0-9]+$", "", $i); \
            if ($i ~ /'"$awkcur"'/) {print $i} \
            }}' "${kh[@]}" 2>/dev/null ) )
        fi
        if [ ${#khd[@]} -gt 0 ]; then
            # Needs to look for files called
            # .../.ssh2/key_22_<hostname>.pub
            # dont fork any processes, because in a cluster environment,
            # there can be hundreds of hostkeys
            for i in "${khd[@]}" ; do
                if [[ "$i" == *key_22_$awkcurd*.pub ]] && [ -r "$i" ] ; then
                    host=${i/#*key_22_/}
                    host=${host/%.pub/}
                    COMPREPLY=( "${COMPREPLY[@]}" $host )
                fi
            done
        fi
        # append any available aliases from config files
        if [ ${#config[@]} -gt 0 ] && [ -n "$aliases" ]; then
            local host_aliases=$( sed -ne 's/^[ \t]*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\?['"$'\t '"']\+\([^#*?]*\)\(#.*\)\?$/\2/p' "${config[@]}" )
            hosts=$( compgen -W "$host_aliases" -- "$cur" )
            COMPREPLY=( "${COMPREPLY[@]}" $hosts )
        fi

        # Add hosts reported by avahi, if it's available
        # and if the daemon is started.
        # The original call to avahi-browse also had "-k", to avoid
        #  lookups into avahi's services DB. We don't need the name
        #  of the service, and if it contains ";", it may mistify
        #  the result. But on Gentoo (at least), -k isn't available
        #  (even if mentioned in the manpage), so...

        # This feature is disabled because it does not scale to
        #  larger networks. See:
        # https://bugs.launchpad.net/ubuntu/+source/bash-completion/+bug/510591
        #if type avahi-browse >&/dev/null; then
        #    if [ -n "$(pidof avahi-daemon)" ]; then
        #        COMPREPLY=( "${COMPREPLY[@]}" $(
        #        compgen -W "$( avahi-browse -cpr _workstation._tcp | \
        #        grep ^= | cut -d\; -f7 | sort -u )" -- "$cur" ) )
        #    fi
        #fi

        # apply suffix and prefix
        for (( i=0; i < ${#COMPREPLY[@]}; i++ )); do
            COMPREPLY[i]=$prefix$user${COMPREPLY[i]}$suffix
        done
    fi

    # Add results of normal hostname completion, unless `COMP_KNOWN_HOSTS_WITH_HOSTFILE'
    # is set to an empty value.
    if [ -n "${COMP_KNOWN_HOSTS_WITH_HOSTFILE-1}" ]; then
        COMPREPLY=( "${COMPREPLY[@]}" $( compgen -A hostname -P "$prefix$user" -S "$suffix" -- "$cur" ) )
    fi

    return 0
}
complete -F _known_hosts traceroute traceroute6 tracepath tracepath6 \
ping ping6 fping fping6 telnet host nslookup rsh rlogin ftp dig ssh-installkeys mtr

# This meta-cd function observes the CDPATH variable, so that cd additionally
# completes on directories under those specified in CDPATH.
#
_cd()
{
    local IFS=$'\t\n' cur=`_get_cword` i j k

    # try to allow variable completion
    if [[ "$cur" == ?(\\)\$* ]]; then
        COMPREPLY=( $( compgen -v -P '$' -- "${cur#?(\\)$}" ) )
        return 0
    fi

    # Enable -o filenames option, see Debian bug #272660
    compgen -f /non-existing-dir/ >/dev/null

    # Use standard dir completion if no CDPATH or parameter starts with /,
    # ./ or ../
    if [ -z "${CDPATH:-}" ] || [[ "$cur" == ?(.)?(.)/* ]]; then
        _filedir -d
        return 0
    fi

    local -r mark_dirs=$(_rl_enabled mark-directories && echo y)
    local -r mark_symdirs=$(_rl_enabled mark-symlinked-directories && echo y)

    # we have a CDPATH, so loop on its contents
    for i in ${CDPATH//:/$'\t'}; do
        # create an array of matched subdirs
        k="${#COMPREPLY[@]}"
        for j in $( compgen -d $i/$cur ); do
            if [[ ( $mark_symdirs && -h $j || $mark_dirs && ! -h $j ) && ! -d ${j#$i/} ]]; then
                j="${j}/"
            fi
            COMPREPLY[k++]=${j#$i/}
        done
    done

    _filedir -d

    if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
        i=${COMPREPLY[0]}
        if [ "$i" == "$cur" ] && [[ $i != "*/" ]]; then
            COMPREPLY[0]="${i}/"
        fi
    fi

    return 0
}
if shopt -q cdable_vars; then
    complete -v -F _cd $nospace cd
else
    complete -F _cd $nospace cd
fi

# a wrapper method for the next one, when the offset is unknown
_command()
{
    local offset i

    # find actual offset, as position of the first non-option
    offset=1
    for (( i=1; i <= COMP_CWORD; i++ )); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            offset=$i
            break
        fi
    done
    _command_offset $offset
}

# A meta-command completion function for commands like sudo(8), which need to
# first complete on a command, then complete according to that command's own
# completion definition - currently not quite foolproof (e.g. mount and umount
# don't work properly), but still quite useful.
#
_command_offset()
{
    local cur func cline cspec noglob cmd i char_offset word_offset \
    _COMMAND_FUNC _COMMAND_FUNC_ARGS

    word_offset=$1

    # rewrite current completion context before invoking
    # actual command completion

    # find new first word position, then
    # rewrite COMP_LINE and adjust COMP_POINT
    local first_word=${COMP_WORDS[$word_offset]}
    for (( i=0; i <= ${#COMP_LINE}; i++ )); do
        if [[ "${COMP_LINE:$i:${#first_word}}" == "$first_word" ]]; then
            char_offset=$i
            break
        fi
    done
    COMP_LINE=${COMP_LINE:$char_offset}
    COMP_POINT=$(( COMP_POINT - $char_offset ))

    # shift COMP_WORDS elements and adjust COMP_CWORD
    for (( i=0; i <= COMP_CWORD - $word_offset; i++ )); do
        COMP_WORDS[i]=${COMP_WORDS[i+$word_offset]}
    done
    for (( i; i <= COMP_CWORD; i++ )); do
        unset COMP_WORDS[i];
    done
    COMP_CWORD=$(( $COMP_CWORD - $word_offset ))

    COMPREPLY=()
    cur=`_get_cword`

    if [[ $COMP_CWORD -eq 0 ]]; then
        COMPREPLY=( $( compgen -c -- "$cur" ) )
    else
        cmd=${COMP_WORDS[0]}
        if complete -p $cmd &>/dev/null; then
            cspec=$( complete -p $cmd )
            if [ "${cspec#* -F }" != "$cspec" ]; then
                # complete -F <function>

                # get function name
                func=${cspec#*-F }
                func=${func%% *}

                if [[ ${#COMP_WORDS[@]} -ge 2 ]]; then
                    $func $cmd "${COMP_WORDS[${#COMP_WORDS[@]}-1]}" "${COMP_WORDS[${#COMP_WORDS[@]}-2]}"
                else
                    $func $cmd "${COMP_WORDS[${#COMP_WORDS[@]}-1]}"
                fi

                # remove any \: generated by a command that doesn't
                # default to filenames or dirnames (e.g. sudo chown)
                # FIXME: I'm pretty sure this does not work!
                if [ "${cspec#*-o }" != "$cspec" ]; then
                    cspec=${cspec#*-o }
                    cspec=${cspec%% *}
                    if [[ "$cspec" != @(dir|file)names ]]; then
                        COMPREPLY=("${COMPREPLY[@]//\\\\:/:}")
                    fi
                fi
            elif [ -n "$cspec" ]; then
                cspec=${cspec#complete};
                cspec=${cspec%%$cmd};
                COMPREPLY=( $( eval compgen "$cspec" -- "$cur" ) );
            fi
        fi
    fi

    [ ${#COMPREPLY[@]} -eq 0 ] && _filedir
}
complete -F _command $filenames nohup exec nice eval time ltrace then \
    else do vsound command xargs tsocks

_root_command()
{
    PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin _command $1 $2 $3
}
complete -F _root_command $filenames sudo fakeroot really gksudo gksu kdesudo

_longopt()
{
    local cur prev

    cur=`_get_cword`
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if _split_longopt; then
        case "$prev" in
            *[Dd][Ii][Rr]*)
                _filedir -d
                ;;
            *[Ff][Ii][Ll][Ee]*)
                _filedir
                ;;
        esac
        return 0
    fi

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W "$( $1 --help 2>&1 | sed -e '/--/!d' \
            -e 's/.*\(--[-A-Za-z0-9]\+\).*/\1/' |sort -u )"\
            -- "$cur" ) )
    elif [[ "$1" == rmdir ]]; then
        _filedir -d
    else
        _filedir
    fi
}
# makeinfo and texi2dvi are defined elsewhere.
for i in a2ps autoconf automake bc gprof ld nm objcopy objdump readelf strip \
    bison diff patch enscript cp df dir du ln ls mkfifo mknod mv rm \
    touch vdir awk gperf grep grub indent less m4 sed shar date \
    tee who texindex cat csplit cut expand fmt fold head \
    md5sum nl od paste pr ptx sha1sum sort split tac tail tr unexpand \
    uniq wc ldd bash id irb mkdir rmdir; do
    have $i && complete -F _longopt $filenames $i
done

# These commands do not use filenames, so '-o filenames' is not needed.
for i in env netstat seq uname units; do
    have $i && complete -F _longopt $default $i
done
unset i

# look(1) completion
#
have look &&
_look()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [ $COMP_CWORD = 1 ]; then
        COMPREPLY=( $( compgen -W '$(look "$cur" 2>/dev/null)' ) )
    fi
} &&
complete -F _look $default look

# id(1) completion
#
have id &&
_id()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W '-a -g --group -G --groups -n --name\
            -r --real -u --user --help --version' -- "$cur" ) )
    else
        COMPREPLY=( $( compgen -u "$cur" ) )
    fi
} &&
complete -F _id id

_filedir_xspec()
{
    local IFS cur xspec

    IFS=$'\t\n'
    COMPREPLY=()
    cur=`_get_cword`

    _expand || return 0

    # get first exclusion compspec that matches this command
    xspec=$( sed -ne $'/^complete .*[ \t]'${1##*/}$'\([ \t]\|$\)/{p;q;}' \
        $BASH_COMPLETION )
    # prune to leave nothing but the -X spec
    xspec=${xspec#*-X }
    xspec=${xspec%% *}

    local -a toks
    local tmp

    toks=( ${toks[@]-} $(
        compgen -d -- "$(quote_readline "$cur")" | {
        while read -r tmp; do
            # see long TODO comment in _filedir() --David
            echo $tmp
        done
        }
        ))

    toks=( ${toks[@]-} $(
        eval compgen -f -X "$xspec" -- "\$(quote_readline "\$cur")" | {
        while read -r tmp; do
            [ -n $tmp ] && echo $tmp
        done
        }
        ))

    COMPREPLY=( "${toks[@]}" )
}
list=( $( sed -ne '/^# START exclude/,/^# FINISH exclude/p' $BASH_COMPLETION | \
    # read exclusion compspecs
    (
    while read line
    do
        # ignore compspecs that are commented out
        if [ "${line#\#}" != "$line" ]; then continue; fi
        line=${line%# START exclude*}
        line=${line%# FINISH exclude*}
        line=${line##*\'}
        list=( "${list[@]}" $line )
    done
    echo "${list[@]}"
    )
    ) )
# remove previous compspecs
if [ ${#list[@]} -gt 0 ]; then
    eval complete -r ${list[@]}
    # install new compspecs
    eval complete -F _filedir_xspec $filenames "${list[@]}"
fi
unset list

# source completion directory definitions
if [ -d $BASH_COMPLETION_COMPAT_DIR -a -r $BASH_COMPLETION_COMPAT_DIR -a \
    -x $BASH_COMPLETION_COMPAT_DIR ]; then
    for i in $BASH_COMPLETION_COMPAT_DIR/*; do
        [[ ${i##*/} != @(*~|*.bak|*.swp|\#*\#|*.dpkg*|*.rpm@(orig|new|save)) ]] &&
        [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
if [ -d $BASH_COMPLETION_DIR -a -r $BASH_COMPLETION_DIR -a \
    $BASH_COMPLETION_DIR != $BASH_COMPLETION_COMPAT_DIR -a \
    -x $BASH_COMPLETION_DIR ]; then
    for i in $BASH_COMPLETION_DIR/*; do
        [[ ${i##*/} != @(*~|*.bak|*.swp|\#*\#|*.dpkg*|*.rpm@(orig|new|save)) ]] &&
        [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
unset i

# source user completion file
[ $BASH_COMPLETION != ~/.bash_completion -a -r ~/.bash_completion ] \
    && . ~/.bash_completion
unset -f have
unset UNAME USERLAND default dirnames filenames have nospace bashdefault \
    plusdirs compopt

set $BASH_COMPLETION_ORIGINAL_V_VALUE
unset BASH_COMPLETION_ORIGINAL_V_VALUE

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
