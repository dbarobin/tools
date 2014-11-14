#!/bin/ksh
#FileName:auto_get_untransferred_shop.sh
#Author:Robin
#Date:2014-3-13 16:00:34
#Desc:Auto get untransfferd shop infomation. Use this script in RHEL 6.1.

#设置以逗号作为行分隔
IFS=,

#获得当前日期，并作格式上的处理
curyear=`date +"%Y"`
curmon=`date +"%m" | sed -e 's/^0//' -e 's/ 0/ /g'`
curday=`date -d yesterday +%d`

curdate=$curyear$curmon$curday

#设置存储中间结果的文件
result="result.txt"
#设置存储最终删选结果的文件
final="final_result.txt"

#每次删选时清空结果文件，便于下次删选
echo "" > $result
echo "" > $final

#打印表头
echo "零售商号,零售名,门店号,门店名,日期" > $result

#循环读取源数据，并分割所有的列
while read field1 field2 field3 field4 field5 field6 field7 field8 field9 field10 field11 field12
do
	#判断是昨天的数据
	#手动这样判断：$field6='2014\/3\/12'
	year=`echo $field6 | awk -F"/" '{print $1}'`
	mon=`echo $field6 | awk -F"/" '{print $2}'`
	day=`echo $field6 | awk -F"/" '{print $3}'`
	newfield6=$year$mon$day
	if [ $newfield6 -eq $curdate ]
	then
		#如果发现有传包异常的数据，则记录下来
		if [ $field9 -eq 0 ] || [ $field10 -eq 0 ] || [ $field11 -eq 0 ] || [ $field12 -eq 0 ]
		then
			echo $field2,$field3,$field4,$field5,$curdate >> $result
		fi
	fi
done < $1

#得到最终结果
cat result.txt | uniq -c | awk '{print $2}' > $final

#得到最终结果的每一列数据
cat $final | awk -F"," '{print $1}' > final_1.txt
cat $final | awk -F"," '{print $2}' > final_2.txt
cat $final | awk -F"," '{print $3}' > final_3.txt
cat $final | awk -F"," '{print $4}' > final_4.txt
cat $final | awk -F"," '{print $5}' > final_5.txt

echo "Completed!"
