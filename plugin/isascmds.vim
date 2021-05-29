

" GPL-3.0 License

" prevent the plugin from loading twice
if exists('g:loaded_isas') | finish | endif

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" main {{{
lua require('isas.main').main(0, 'load_at_startup')
" }}}


let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

" set to true the var that controls the plugin's loading state
let g:loaded_isas = 1
