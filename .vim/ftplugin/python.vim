setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
autocmd BufWritePre <buffer> :%s/\s\+$//e

nnoremap <F5> :!python %:p<CR>

if exists('&colorcolumn')
	set colorcolumn=81
else
	2mat ErrorMsg '\%81v.'
endif
