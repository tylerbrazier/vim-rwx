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

	nnoremap <buffer> <expr> rm join([':RWX! rm -r', getline('.')])
	nnoremap <buffer> <expr> mv join([':RWX! mv', getline('.'), getline('.')])
	nnoremap <buffer> <expr> cp join([':RWX cp -r', getline('.'), getline('.')])
	exe 'nnoremap <buffer> cd :lcd' fnamemodify(d, ':~') '<CR>'
	exe 'nnoremap <buffer> mk :RWX mkdir' fnamemodify(d, ':~')
endfunction

function s:mkentry(d, f)
	let path = a:d..a:f
	if isdirectory(path) && a:f != '..'
		let path ..= '/'
	endif
	return fnamemodify(path, ':~')
endfunction

function s:bd(args) abort
	let bufnrs = split(a:args)
			\->filter('!empty(v:val)')
			\->map('bufnr(fnamemodify(v:val, ":p"))')
			\->filter('v:val != -1')
	if !empty(bufnrs)
		 exe 'bd' join(bufnrs)
	endif
endfunction

command -nargs=+ -bang -complete=file RWX
			\ if !empty('<bang>') | call <SID>bd(<q-args>) | endif
			\|exe '!'..<q-args>
			\|edit
