

" GPL-3.0 License

" prevent the plugin from loading twice
if exists('g:loaded_isas') | finish | endif

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" Utils {{{
function! isascmds#get_first_arg(...)
	return "".get(a:, 1, 1).""
endfunction
" }}}


" Test Availability {{{
function! isascmds#aa_dictionaries() abort
	return luaeval('require("isas.completions.aa_dictionaries").available_commands()')
endfunction

function! isascmds#aa_available_dictionaries() abort
	return luaeval('require("isas.completions.aa_available_dictionaries").available_commands()')
endfunction
" }}}

" Tab Completion {{{
function! s:complete_aa_dictionaries(arg, line, pos) abort
	return join(isascmds#aa_dictionaries(), "\n")
endfunction

function! s:complete_aa_available_dictionaries(arg, line, pos) abort
	return join(isascmds#aa_available_dictionaries(), "\n")
endfunction
" }}}


" main {{{
lua require('isas.main').main(0, 'load_at_startup')
" }}}

" Interface {{{
command! -nargs=* -complete=custom,s:complete_aa_available_dictionaries ISASLoad call v:lua.require("isas.main").main(1,isascmds#get_first_arg(<f-args>))
command! -nargs=* -complete=custom,s:complete_aa_dictionaries ISASUnload call v:lua.require("isas.main").main(2,isascmds#get_first_arg(<f-args>))
" }}}


let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

" set to true the var that controls the plugin's loading state
let g:loaded_isas = 1

