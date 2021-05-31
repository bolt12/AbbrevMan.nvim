

" GPL-3.0 License

" prevent the plugin from loading twice
if exists('g:loaded_abbrev_man') | finish | endif

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" Utils {{{
function! amcmds#get_first_arg(...)
	return "".get(a:, 1, 1).""
endfunction
" }}}


" Test Availability {{{

" aa = available arguments

function! amcmds#aa_dictionaries() abort
	return luaeval('require("abbrev-man.completions.aa_dictionaries").available_commands()')
endfunction

function! amcmds#aa_available_dictionaries() abort
	return luaeval('require("abbrev-man.completions.aa_available_dictionaries").available_commands()')
endfunction

function! amcmds#aa_loaded_dictionaries() abort
	return luaeval('require("abbrev-man.completions.aa_loaded_dictionaries").available_commands()')
endfunction
" }}}

" Tab Completion {{{
function! s:complete_aa_dictionaries(arg, line, pos) abort
	return join(amcmds#aa_dictionaries(), "\n")
endfunction

function! s:complete_aa_available_dictionaries(arg, line, pos) abort
	return join(amcmds#aa_available_dictionaries(), "\n")
endfunction

function! s:complete_aa_loaded_dictionaries(arg, line, pos) abort
	return join(amcmds#aa_loaded_dictionaries(), "\n")
endfunction
" }}}


" main {{{
lua require('abbrev-man.main').main(0, 'load_natural_dictionaries_at_startup')
lua require('abbrev-man.main').main(0, 'load_programming_dictionaries_at_startup')
" }}}

" Interface {{{
command! -nargs=* -complete=custom,s:complete_aa_available_dictionaries amLoad call v:lua.require("abbrev-man.main").main(1,amcmds#get_first_arg(<f-args>))
command! -nargs=* -complete=custom,s:complete_aa_loaded_dictionaries amUnload call v:lua.require("abbrev-man.main").main(2,amcmds#get_first_arg(<f-args>))
" }}}


let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

" set to true the var that controls the plugin's loading state
let g:loaded_abbrev_man = 1

