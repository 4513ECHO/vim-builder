# vim-builder

Auto vim builder

## Usage
```
Usage: ./vim-builder.sh [OPTIONS]

Options:
  -h --help                       show this message and exit
  -v --vim-version <VIM_VERSION>  set vim version (default: 8.2.3616)
  -p --prefix <PREFIX>            set directory installed vim (default: /usr/local/)
  -n --name <NAME>                set "compiled by" (default: "vim-builder.sh")
```

**Note:** My useful oneliner command:

```sh
sudo ./vim-builder.sh --name "Hibiki (4513ECHO)" --vim-version "$(cd $(ghq root)/github.com/vim/vim && git pull --quiet && git describe --tags --abbrev=0)"
```

## Lisence

MIT
