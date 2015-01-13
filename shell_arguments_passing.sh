#!/bin/bash
# Author: yangzhongxuan
# Date: 14:07:11 2014-12-04
# Desc: extracting command text_text_text_line options as parameters
# From: http://blog.csdn.net/yangzhongxuan/article/details/7002739

help_info(){
    echo "NAME"
    echo "\t$0"
    echo "SYNOPSIS"
    echo "\t$0 is a shell test about process options"
    echo "DESCRIPTION"
    echo "\toption like -a -b param1 -c param2 -d"
}

if [ $# -lt 0 ]
then
    help_info
fi

nomal_opts_act()
{
    echo -e "\n### nomal_opts_act ###\n"

    while [ -n "$1" ]
    do
    case "$1" in 
        -a)
            echo "Found the -a option"
            ;;
        -b)
            echo "Found the -b option"
            echo "The parameter follow -b is $2" 
            shift
            ;;
        -c)
            echo "Found the -c option"
            echo "The parameter follow -c is $2"
            shift
            ;;
        -d)
            echo "Found the -d option"
            ;;
         *)
             echo "$1 is not an option"
            ;;
    esac
    shift
    done
}

#用shell命令自建的选项解析，可以按照自己的想法实现
#优点：自己定制，没有做不到，只有想不到
#缺点：麻烦

getopt_act()
{
    echo -e "\n### getopt_act ###\n"

    GETOPTOUT=`getopt ab:c:d "$@"`
    set -- $GETOPTOUT 
    while [ -n "$1" ] 
    do
    case $1 in 
        -a)
            echo "Found the -a option"
            ;;
        -b)
            echo "Found the -b option"
            echo "The parameter follow -b is "$2""
            shift
            ;;
        -c)
            echo "Found the -c option"
            echo "The parameter follow -c is "$2""
            shift
            ;;
        -d)
            echo "Found the -d option"
            ;;
        --)
            shift
            break
            ;;
         *)
             echo "Unknow option: "$1""
            ;;
    esac
    shift
    done

    param_index=1
    for param in "$@"
    do
        echo "Parameter $param_index:$param"
        param_index=$[ $param_index + 1 ] 
    done
}

#用getopt命令解析选项和参数
#优点：相对与getopts来说是个半自动解析，自动组织选项和参数，用 -- 符号将选项与参数隔开
#缺点：相对于getopts的缺点
#1.需要与set -- 命令配合，不是必须，需要手动shift
#2.选项参数中不支持空格如 -a -b dog -c "earth moon" -d -f param1 param2 就会解析错误

getopts_act()
{
    echo -e "\n### getopts_act ###\n"
    while getopts :ab:c:d ARGS
    do
    case $ARGS in 
        a)
            echo "Found the -a option"
            ;;
        b)
            echo "Found the -b option"
            echo "The parameter follow -b is $OPTARG"
            ;;
        c)
            echo "Found the -c option"
            echo "The parameter follow -c is $OPTARG"
            ;;
        d)
            echo "Found the -d option"
            ;;
         *)
             echo "Unknow option: $ARGS"
            ;;
    esac
    done

    shift $[ $OPTIND -1 ] 
    param_index=1
    for param in "$@"
    do
        echo "Parameter $param_index:$param"
        param_index=$[ $param_index + 1 ] 
    done
}

# getopts 命令解析选项和参数
# 优点：可在参数中包含空格如：-c "earth moon"
#            选项字母和参数值之间可以没有空格如：-bdog
#            可将未定义的选项绑定到?输出
#            Unknow option: ?

nomal_opts_act -a -b dog -c earth -d -f param1 param2
getopts_act -a -b dog -c "earth moon" -d -f param1 param2
getopt_act -a -b dog -c earth -d -f param1 param2
