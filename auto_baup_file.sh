#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Desc:Auto backup files to remote file server.

rsync -avRl /webbackup/ /bakvg/web_backup/ > /dev/null 2>&1
rsync -avRl /sqlbackup/ /bakvg/sql_backup/ > /dev/null 2>&1
rsync -avRl /ftpbackup/ /bakvg/ftp_backup/ > /dev/null 2>&1
