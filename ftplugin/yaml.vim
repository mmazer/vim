setlocal sw=2
setlocal sts=2
setlocal fdm=indent

autocmd BufWritePre *.yaml call vimutils#trim_trailing_lines()
