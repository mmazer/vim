#### Vim Configuration 

Vim configuration files based on XDG directories which can be configured with environment variables:


    export XDG_CONFIG_HOME=$HOME/.config
    export XDG_DATA_HOME=$HOME/.local/share
    export XDG_CACHE_HOME=$HOME/.cache

Set `VIMNIT` environment variable:

    export VIMINIT=let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC

This configuration can also be used with Neovim. Any Neovim specific configuration can be wrapped in:

    if has('nvim')
      ...
    endif

#### References

 - <http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables>
 - <http://tlvince.com/vim-respect-xdg>
