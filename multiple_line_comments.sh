#!/bin/bash

:||{
   Scripts info:
   Author: Robin Wen
   Date: 16:45:28 03-25-2015
   Desc: Mutiple line comments.
   Ref: http://t.cn/RA2psCn
}

:<<BLOCK
   The first method.
   Comments.
BLOCK


:||{

   The second method.

   IP and hostname match table.
   Hostname        IP
   Master
   xxx             xxx.xxx.xxx.xxx
   
   App
   xxx             xxx.xxx.xxx.xxx
   
   Database
   xxx             xxx.xxx.xxx.xxx
   
   App
   xxx             xxx.xxx.xxx.xxx
   
   App
   xxx             xxx.xxx.xxx.xxx
}

if false; then
   The third method.
   Comments.
fi

# Test command.
echo "Hello, this script tells how to make multi-line comments."
