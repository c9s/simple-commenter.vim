
SimpleCommenter
===============
Support most file type.

Depends on 'commentstring' option

Author: Cornelius 林佑安 <cornelius.howl@gmail.com>

Date:   四  3/ 4 14:39:34 2010

Options
===============
These options could be added to your ~/.vimrc file.

If you dont want default mapping:

    let g:scomment_default_mapping = 1

If you prefer comment mark from `commentstring` option:

    let g:prefer_commentstring = 1

Online comment mark padding:

    let g:oneline_comment_padding = ' '

Block comment mark padding

    let g:block_comment_padding = " "

Reselect after (un)commenting

    let g:scomment_reselect = 1

Default Mappings
================

    ,c    Comment
    ,C    Uncomment
    ,,    oneline commment toggle


Custom Mapping
==============
Add these line to your vimrc:


    map <silent>   <leader>c    <Plug>(do-comment)
    map <silent>   <leader>C    <Plug>(un-comment)
    map <silent>   ,,           <Plug>(one-line-comment)

Commands
========

    :DoComment
    :UnComment
    :OneLineComment




