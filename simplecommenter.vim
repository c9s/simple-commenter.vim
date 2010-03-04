" Simple Commenter
"   Support most file type.
"   Depends on 'commentstring' option
"
"   Author: Cornelius 林佑安 <cornelius.howl@gmail.com>
"   Date:   四  3/ 4 14:39:34 2010
"   Github: http://github.com/c9s
"   Script Type: plugin
"
fun! s:doComment(a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )
  if len(css) == 1
    " single comment mark
    for i in range(a:a,a:e)
      let line = printf(cs,getline(i))
      cal setline(i,line)
    endfor
  elseif len(css) == 2
    " has comment start mark and end mark
    let line = css[0] . getline(a:a)
    cal setline(a:a,line)

    let line = getline(a:e) . css[1]
    cal setline(a:e,line)
  endif
endf

fun! s:unComment(a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )
  if len(css) == 1
    " single comment mark
    for i in range(a:a,a:e)
      let line = substitute(getline(i),'^'.css[0],'','')
      cal setline(i,line)
    endfor
  elseif len(css) == 2
    " has comment start mark and end mark
    let css[0] = escape( css[0] , '.*' )
    let css[1] = escape( css[1] , '.*' )

    let line = substitute(getline(a:a),'^'.css[0],'','')
    cal setline(a:a,line)

    let line = substitute(getline(a:e),css[1].'$','','')
    cal setline(a:e,line)
  endif
endf
com! -range DoComment :cal s:doComment(<line1>,<line2>)
com! -range UnComment :cal s:unComment(<line1>,<line2>)
map <silent>   ,c    :DoComment<CR>
map <silent>   ,C    :UnComment<CR>

