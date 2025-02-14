
if exists('g:loaded_url_by_regex')
    finish
endif
let g:loaded_url_by_regex = 1

command! URLOpenByRegex lua require('url-by-regex').open_url_by_regex()
