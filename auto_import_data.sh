#!/bin/bash
#FileName:auto_import_data.sh
#Desc:Auto Import Data To MS SQL
#Date:2014-3-14 17:53:12
#Author:Robin

#1.分离数据
awk -F"," '{print $1}' source.txt > source1.txt
awk -F"," '{print $2}' source.txt > source2.txt
awk -F"," '{print $3}' source.txt > source3.txt
awk -F"," '{print $4}' source.txt > source4.txt

#2.在行首和行尾添加单引号
sed 's/\ \+$//' source1.txt -i
sed 's/^/yy/g' source1.txt -i
sed 's/$/zz/g' source1.txt -i
sed "s/yy/\'/g" source1.txt -i
sed "s/zz/\'/g" source1.txt -i

sed 's/^/yy/g' source2.txt -i
sed 's/$/zz/g' source2.txt -i
sed "s/yy/\'/g" source2.txt -i
sed "s/zz/\'/g" source2.txt -i

sed 's/^/yy/g' source3.txt -i
sed 's/$/zz/g' source3.txt -i
sed "s/yy/\'/g" source3.txt -i
sed "s/zz/\'/g" source3.txt -i

sed 's/^/yy/g' source4.txt -i
sed 's/$/zz/g' source4.txt -i
sed "s/yy/\'/g" source4.txt -i
sed "s/zz/\'/g" source4.txt -i

#3.合并文件
paste -d "," source1.txt source2.txt source3.txt source4.txt > result.txt

#4.拼接为最终的插入语句
sed 's/^/INSERT INTO ##temp VALUES(/g' result.txt -i
sed 's/$/);/g' result.txt -i