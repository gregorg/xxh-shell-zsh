#!/usr/bin/env sh

if [ -e /bin/zsh ]
then
    exec /bin/zsh "$@"
fi

CDIR="$(cd "$(dirname "$0")" && pwd)"

zshbin='zsh-bin'

zsh_dir=''
if [ -f $CDIR/.zsh_dir ]; then
  zsh_dir=`cat $CDIR/.zsh_dir`
fi

if [ ! "$CDIR" = "$zsh_dir" ]; then
  if [ "$XXH_VERBOSE" = '2' ]; then
    $CDIR/$zshbin/share/zsh/5.8/scripts/relocate
  else
    $CDIR/$zshbin/share/zsh/5.8/scripts/relocate  > /dev/null 2> /dev/null
  fi
  echo $CDIR > $CDIR/.zsh_dir
fi

mkdir -p $XDG_DATA_HOME/zsh

export ZDOTDIR=$CDIR
export PATH=$CDIR/$zshbin/bin:$PATH
export SAVEHIST=10000
export HISTFILE=$XDG_DATA_HOME/zsh/history

exec $CDIR/$zshbin/bin/zsh "$@"
