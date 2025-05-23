#!/usr/bin/env bash

CDIR="$(cd "$(dirname "$0")" && pwd)"

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

build_dir=$CDIR/build

rm -rf $build_dir
mkdir -p $build_dir/zsh-bin

for f in entrypoint.sh zsh.sh
do
    cp $CDIR/$f $build_dir/
done
cp $CDIR/zshrc $build_dir/.zshrc

# tag=$(curl --silent https://api.github.com/repos/romkatv/zsh-bin/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
tag=v6.1.1
#arch=$(uname -m)
# Force x86_64
arch="x86_64"
if [[ $arch == x86_64* ]]; then
	distfile=zsh-5.8-linux-x86_64
elif [[ $arch == arm* ]]; then
	distfile=zsh-5.8-linux-armv7l
fi


url="https://github.com/romkatv/zsh-bin/releases/download/$tag/$distfile.tar.gz"
tarname=`basename $url`

cd $build_dir/zsh-bin

[ $QUIET ] && arg_q='-q' || arg_q=''
[ $QUIET ] && arg_s='-s' || arg_s=''
[ $QUIET ] && arg_progress='' || arg_progress='--progress bar'

if [ -x "$(command -v wget)" ]; then
  wget $arg_q $arg_progress $url -O $tarname
elif [ -x "$(command -v curl)" ]; then
  curl $arg_s -L $url -o $tarname
else
  echo Install wget or curl
fi

tar -xzf $tarname
if [[ $arch == x86_64* ]]; then
mv zsh-5.8-linux-x86_64/* .
elif  [[ $arch == arm* ]]; then
mv zsh-5.8-linux-armv7l/* .
fi

rm $tarname
