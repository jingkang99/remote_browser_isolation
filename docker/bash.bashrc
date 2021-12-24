# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

#--- devop
export GOROOT=/opt/go
export GOPATH=/opt/gowww

export LD_LIBRARY_PATH=/usr/local/lib
export PATH=/opt/zeroadmin/turbovnc/bin:opt/node/bin:/opt/kafka/bin:/opt/mongodb/bin:/opt/maven/bin:/opt/sbt/bin:/opt/scala/bin:/opt/java/bin:/opt/spark/bin:/opt/hadoop/bin:/opt/hbase/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export NODE_HOME=/opt/node
export JAVA_HOME=/opt/java
export SCALA_HOME=/opt/scala
export SPARK_HOME=/opt/spark
export CLASSPATH=/opt/spark/jars

LS_COLORS="no=00:fi=00:di=00;35:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"  
export LS_COLORS

alias ls='ls --color'
alias vvl='virsh list --all'

function dush(){
    du -h --max-depth=1 $1
}

function ghstars() {
  user_repo="$@"
  curl -s https://api.github.com/repos/${user_repo} | \
    grep 'stargazers_count' | \
    grep -o -P '(?<=:).*(?=,)' | \
    grep -o -P '(?<= ).*'
}

alias gg='git log --all --decorate --oneline --graph'
alias gu='git pull'
alias ga='/bin/ls -D | xargs -I{} grep git {}/.git/config'
alias gd="for fd in \$( /bin/ls -D ) ; do cd \$fd; pwd; echo; git pull; cd - ; done"
alias gh='git checkout HEAD'
alias gr='grep url .git/config'

alias nz='netstat -nltup'
alias ot="fs=$(df / | tail -1 | cut -f1 -d' ') && tune2fs -l $fs | grep created"
alias ds="du -khd 1"
alias st='systemctl list-unit-files --state=enabled --no-pager'

alias dsus='dush .'
alias ipaa="ip a | grep -P '^2: ' -A 2 | grep inet | awk '{print \$2}'| awk -F'/' '{print \$1}'"
alias ccss='for rf in *.rules; do printf "%6d  %s\n" $(grep -P "^alert" $rf | wc -l) $rf ; done'
alias pspp='ps -ef | grep -v \\['
alias pscc='ps -ef | grep    \\[ | wc -l'
alias c000='cat /dev/zero > /root/zero.0; sync; rm -rf /root/zero.0; sync'
alias tttk='head -c 32 /dev/urandom | shasum | cut -d" " -f1'
alias tset='htpdate -t -s ntp.neu.edu.cn'

alias psize="awk '{if (\$1 ~ /Package/) p = \$2; if (\$1 ~ /Installed/) printf(\"%9d %s\n\", \$2, p)}' /var/lib/dpkg/status | sort -n"
alias fsshd='fail2ban-client status sshd' 
alias rmrcs="apt purge `dpkg --list | grep ^rc | awk '{ print $2; }'`"
alias myip='curl ipv4.icanhazip.com'
alias ipip='wget http://ipinfo.io/ip -qO -'

alias dps='docker ps --all'
alias dip='docker ps --format "{{.ID}}" | xargs docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dim='docker images --all'
alias dss='docker stats'
alias dpf='docker ps --no-trunc'
alias lll='ls -ltr'
alias nel='netstat -ltnp'

alias pkl="dpkg-query -Wf '\${db:Status-Status} \${Installed-Size}\t\${Package}\n'"

alias rmca='sync && echo 3 > /proc/sys/vm/drop_caches'

function dat(){
    docker exec -it $1 /bin/sh 
}
function dtt(){
    docker top $1 
}
function dst(){
    docker restart $1
}
function dpp(){
    docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $1
}

function pks(){
    apt show $1 2>&1 | grep kB
}
