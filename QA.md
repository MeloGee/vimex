# 常见问题与解决方式
## 1.全局搜索:leader gg失效问题

    自己修改快捷键映射在ex-gsearch中修改,autoload中是函数定义,plugin中的是具体的映射,实际上函数的定义就是用lid去查找tag:
    lid --result=grep -i -f .exvim.phub/ID -s map_file_in " 这个是查找全部的tags

    命令在~/.vim/bundle/ex-gsearch/plugin/exgsearch.vim 中增加:
    call exgsearch#register_hotkey( 12 , 1, '<leader>]'       , ":GS expand('<cword>') <CR>"                , 'Reverse filter files in search result.' )

    注意:部分环境下该方法有冲突,则可以用最简单的方法实现,即vim map命令映射, map <leader>gg:EXGSearchCWord<CR>即可


## 2.全局搜索:tags生成失败,lid提示位置的选项问题

    多为mkid、lid错误,即Update命令没能成功运行,故此需要查看mkid、lid是否有权限使用


## 3.lid unknow option 问题

    Error parsing arguments: unknown option.
    Usage: lid [-ign?] [-i|--interactive] [-g|--group] [-n|--onlynames] [-?|--help]
            [--usage] [OPTION...] user

    正常使用经过测试lid --version 4.6  如果lid --version都不能正常执行说明版本不对，更正版本后即可解决


## 4.函数列表

    TlistToggle  可以设置快捷键: map xxx:TlistToggle<CR>  默认是F4为函数列表快捷键


## 5.跳转

    所有的跳转  全局搜索都要给予tags  故此需要安装ctags  一般都会带有这个,是一个软件而不是插件
    yum install ctags

    该套配置默认支持C/C++ go 语言跳转，支持python、shell、sql等常见脚本语言的关键字高亮、格式化

