if exists("g:loaded_rwx") || &cp
	finish
endif
let g:loaded_rwx = 1

augroup rwx
	autocmd!
	" disable netrw when editing a dir
	autocmd VimEnter * autocmd! FileExplorer
	autocmd BufEnter * call s:ls()
augroup END

function s:ls()
	let d = expand('%:p')

	if !isdirectory(d)
		return
	endif

	" use filetype=netrw for the syntax highlighting
	setl filetype=netrw buftype=nofile

	" clear any lines first in case files have changed
	call deletebufline('', 1, '$')

	call setline(1, s:mkentry(d, '..'))
	call foreach(readdir(d), {i,f -> setline(i+2, s:mkentry(d, f))})
endfunction

function s:mkentry(d, f)
	let path = a:d..a:f
	if isdirectory(path) && a:f != '..'
		let path ..= '/'
	endif
	return fnamemodify(path, ':~')
endfunction
