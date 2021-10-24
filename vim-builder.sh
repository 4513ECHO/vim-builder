#!/bin/sh

help () {
  cat <<'END'
Usage: ./vim-builder.sh [OPTIONS]

Options:
  -h --help                       show this message and exit
  -v --vim-version <VIM_VERSION>  set vim version (default: 8.2.3560)
  -p --prefix <PREFIX>            set directory installed vim (default: /usr/local/)
  -n --name <NAME>                set "compiled by" (default: "vim-builder.sh")
END
  exit 0
}

log () {
  cat - | awk '{$0="\033[1;'"$1"'m['"$2"']\033[m "$0; print}'
}

abort () {
  printf "\033[1;31m[error!]\033[m %s\n" "$*" >&2
  exit 1
}

unknown () {
  abort "unrecognized option '$1'"
}

required () {
  [ $# -gt 1 ] || abort "option '$1' requires an argment"
}

parse_options () {
  FLAG_HELP='' PREFIX='' VIM_VERSION='' NAME=''
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help) FLAG_HELP=1 ;;
      -v | --vim-version) required "$@" && shift; VIM_VERSION=$1 ;;
      -p | --prefix) required "$@" && shift; PREFIX=$1 ;;
      -n | --name) required "$@" && shift; NAME=$1 ;;
      -?*) unknown "$@" ;;
      *) break
    esac
    shift
  done
  VIM_VERSION="${VIM_VERSION:-8.2.3560}"
  NAME="${NAME:-vim-builder.sh}"
  PREFIX="${PREFIX:-/usr/local/}"
}

DEPENDS="
  'gettext'
  'libtinfo-dev'
  'libacl1-dev'
  'libgpm-dev'
  'libncurses-dev'
  'build-essential'
  'libperl-dev'
  'python-dev'
  'python3-dev'
  'ruby-dev'
  'tcl-dev'
  'lua5.4'
  'liblua5.4-dev'
  'luajit'
  'libluajit-5.1-dev'
  'libx11-dev'
  'xorg-dev'
"

main () {
  parse_options "$@"
  [ -n "$FLAG_HELP" ] && help
  [ "$USER" != "root" ] && abort "please do 'sudo'"

  apt-get update | log 33 apt
  apt-get install -y $(echo "$DEPENDS" | tr -d "'\n") | log 33 apt

  if [ -d "vim-${VIM_VERSION}" ]; then
    rm -rf "vim-${VIM_VERSION}"
    printf "Remove directory '%s'\n" "vim-${VIM_VERSION}" | log 35 vim-builder
  fi
  printf "Download into '%s'" "vim-${VIM_VERSION}" | log 35 vim-builder
  curl -fsSL "https://github.com/vim/vim/archive/refs/tags/v${VIM_VERSION}.tar.gz" \
    | tar zxf -
  printf "change directory to src\n" | log 35 vim-builder
  cd "vim-${VIM_VERSION}/src" || abort "fail to change direcoty"

  ./configure \
    --prefix="$PREFIX" \
    --enable-fail-if-missing \
    --enable-luainterp=dynamic \
    --enable-perlinterp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-tclinterp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-cscope \
    --enable-terminal \
    --enable-autoservername \
    --enable-multibyte \
    --enable-xim \
    --enable-fontset \
    --enable-gpm \
    --with-features=huge \
    --with-compiledby="$NAME" \
    --with-luajit \
    --with-x \
    | log 36 configure

  make install | log 32 make
}

main "$@" || exit 1

