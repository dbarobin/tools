#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Log:2013年11月8日10:44:38 add Optimizie system
#Desc:Script of Initialize and Optimizie Linux System. Use this script in RHEL 6.1.

#打印功能菜单
echo "****************************************************************"
echo "		Welcome to Initialize and Optimizie Linux System Menu     "
echo "****************************************************************"
echo "*************	1.Configure Network 		**********************"
echo "*************	2.Update Hostname  		**************************"
echo "*************	3.Shutdown Firewall and SELINUX	******************"
echo "*************	4.Configure Yum source		**********************"
echo "*************	5.Insall vim,man and openssh  		**************"
echo "*************	6.Optimizie System  		**********************"
echo "*************	7.Exit		  		******************************"
echo "****************************************************************"

#死循环，不断接收用户输入
while [ true ];
do
	#接收用户的选择
	read -p "Please input your option(You'd better input by sequence):" option
	case "$option" in
		1)
			#定义网络配置文件
			netfile=/etc/sysconfig/network-scripts/ifcfg-eth0
			echo "Configure Network...";
			#如果网络配置文件存在，那么进行网络配置
			if [ -f "$netfile" ]
			then
				#IPADDR字符串存在的个数
				ipaddr_num=`grep "IPADDR" $netfile | wc -l`
				if [ $ipaddr_num -gt 0 ]
				then
					#接收用户输入的IP地址
					read -p "Input ipaddr(such as 192.168.1.139):" ipaddr
					#判断是否是合法的IP地址
					if [ `echo $ipaddr |  grep "[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[1-9]{1,3}" -E` != "" ]
					then
						#截取IP地址的四段
						ipaddr1=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[1]}'`
						ipaddr2=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[2]}'`
						ipaddr3=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[3]}'`
						ipaddr4=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[4]}'`
						
						#修改IP地址
						`sed "s/(IPADDR)=.*/\1=$ipaddr1\.$ipaddr2\.$ipaddr3\.$ipaddr4/" $netfile -ri`
					else
						echo "IP addr is illegal! Input again:"
					fi
				#如果为0，那么添加IPADDR
				else
					#接收用户输入的IP地址
					read -p "Input ipaddr(such as 192.168.1.139):" ipaddr
					#判断是否是合法的IP地址
                    if [ `echo $ipaddr |  grep "[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[1-9]{1,3}" -E` != "" ]
                    then
						#截取IP地址的四段
						ipaddr1=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[1]}'`
                        ipaddr2=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[2]}'`
                        ipaddr3=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[3]}'`
                        ipaddr4=`echo $ipaddr | awk -F"." '{split($0,arr,".");print arr[4]}'`
						
						#添加IP地址
						`sed "3aIPADDR=$ipaddr1\.$ipaddr2\.$ipaddr3\.$ipaddr4" $netfile -ri`
                    else
                         echo "IP addr is illegal! Input again:"
					fi

				fi
				
				#统计ONBOOT的个数
				onboot=`grep "ONBOOT" $netfile | wc -l`
				#如果大于0，进行修改
                if [ $onboot -gt 0 ]
                then
					#接收用户输入的选项
					read -p "Start network on boot?(Y/y/N/n):" boot
					#如果为Y或者y，修改
					if [[ $boot == "Y" ]] || [[ $boot == "y" ]]
				then
					`sed "s/(ONBOOT)=.*/\1=\"yes\"/" $netfile -ri`
				else
					`sed "s/(ONBOOT)=.*/\1=\"no\"/" $netfile -ri`
				fi
				#如果不为Y或者y，添加
                else
					read -p "Start network on boot?(Y/y/N/n):" boot
                    if [ $boot == "Y" ] || [[ $boot == "y" ]]
						then
                            `sed "2aONBOOT=\"yes\"" $netfile -ri`
                     else
							`sed "2aONBOOT=\"no\"" $netfile -ri`
					fi

				fi
				
				#统计子网掩码的个数
 	            netmask_num=`grep "NETMASK" $netfile | wc -l`
                if [ $netmask_num -gt 0 ]
                then
					#接收用户输入的子网掩码
                    read -p "Input netmask(such as 255.255.255.0):" netmask
					#判断是否是合法的IP地址
                    if [ `echo $netmask |  grep "[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" -E` != "" ]
                    then
						#截取IP地址的四段
                        netmask1=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[1]}'`
                        netmask2=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[2]}'`
                        netmask3=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[3]}'`
                        netmask4=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[4]}'`
						
						#修改子网掩码
                         `sed "s/(NETMASK)=.*/\1=$netmask1\.$netmask2\.$netmask3\.$netmask4/" $netfile -ri`
                    else
                        echo "Netmask is illegal! Input again:"
                    fi
                    else
						#接收用户输入的子网掩码
                        read -p "Input netmask(such as 255.255.255.0):" netmask
						#判断是否是合法的IP地址
						if [ `echo $netmask |  grep "[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" -E` != "" ]
                        then
                            netmask1=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[1]}'`
                            netmask2=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[2]}'`
                            netmask3=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[3]}'`
 	                        netmask4=`echo $netmask | awk -F"." '{split($0,arr,".");print arr[4]}'`
							
							#添加子网掩码
							`sed "2aNETMASK=$netmask1\.$netmask2\.$netmask3\.$netmask4" $netfile -ri`
                        else
                            echo "Netmask is illegal! Input again:"
                        fi

                    fi
			else
				touch $netfile
			fi
			
			#打印配置文件的信息
			echo 'Configure network finished!!!'
			echo "Configure Result:"
			cat $netfile
			#重启网络服务
			echo "Please wait a moment, the network is restarting...."
			`/etc/init.d/network restart > /dev/null 2>&1`
			;;
		2)
			#修改主机名
			echo "Update Hostname..."

			network=/etc/sysconfig/network

			if [ -f "$network" ]
            then
				#接收用户输入的主机名
				hostname=`grep "HOSTNAME" $network | wc -l`
                if [ $hostname -gt 0 ]
                then
                    read -p "Input your hostname(such as robinwen.host.com):" host
					#如果不为空，修改
                    if [ $host != "" ]
                    then
                        `sed "s/(HOSTNAME)=.*/\1=$host/" $network -ri`
                    else
						echo "Hostname is null, input again"
                    fi
                else
					#接收用户输入的主机名
					read -p "Input your hostname:(such as robinwen.host.com)" host
                    if [ $host != "" ]
					#如果不为空，添加
					then
                        `sed "1a=HOSTNAME=$host" $network -ri`
                    else
						echo "Hostname is null, input again"
                	fi
			
                fi

            else
                touch $network
            fi
            echo "Configure hostname finished!!!"
			echo "Configure Result:"
            cat $network
			hostName=`grep "HOSTNAME" $network | awk -F"=" '{print $2}'`
			`hostname $hostName > /dev/null 2>&1`
			;;
		3)
			#改变防火墙和SELINUX
			echo "Shutdown Firewall and SELINUX..."
			`chkconfig NetworkManager off > /dev/null 2>&1`
			`chkconfig iptables off > /dev/null 2>&1`
			`chkconfig ip6tables off > /dev/null 2>&1`
			`/etc/init.d/iptables stop > /dev/null 2>&1`
			`/etc/init.d/ip6tables stop > /dev/null 2>&1`
			`setenforce 0 > /dev/null 2>&1`
			`sed "s/(SELINUX)=.*/\1=disabled/" /etc/sysconfig/selinux -ri`
			echo "Shutdown Firewall Finished!!!"
			;;
		4)
			#配置yum源
			echo "Configure Yum source"
			yumdir=/etc/yum.repos.d
			yumfile=/etc/yum.repos.d/rhel-source.repo
			yumfilecopy=/etc/yum.repos.d/iso.repo
			
			if [ -f "$yumfile" ]
			then
				#接收用户输入的挂载目录
				read -p "Input the yum mount point(such as iso):" point
				if [ $point != "" ]
				then
					#创建目录
					`mkdir /$point > /dev/null 2>&1`
					#拷贝文件
					`cp $yumfile $yumfilecopy -a`
					#修改配置信息
					`sed '7,$d' $yumfilecopy -ri`
					`sed "1s/(\[rhel\-source\])/\[iso\]/" $yumfilecopy -ri`
					version=`cat /etc/redhat-release`	
					`sed "s/(name)=.*/\1=$version/" $yumfilecopy -ri`
					`sed "s/(baseurl)=.*/\1=file:\/\/\/iso/" $yumfilecopy -ri`
					`sed "s/(enabled)=.*/\1=1/" $yumfilecopy -ri`
					`sed "s/(gpgcheck)=.*/\1=0/" $yumfilecopy -ri`
					#挂载
					`mount /dev/cdrom /$point > /dev/null 2>&1`
					#挂载信息写入配置文件，重启生效
					`echo "mount /dev/cdrom /$point" >> /etc/rc.local`
				else
					echo "Input is null, input again"
				fi
			else
				echo "No template file!!!"
			fi
			echo "Configure Yum source finished!!!"
			echo "Configure Result:"
			#打印yum源配置文件
			cat $yumfilecopy
			;;
		5)
			echo "Insall vim,man and openssh..."
			`yum install vim man openssh* -y > /dev/null 2>&1`
			echo "Insall vim,man and openssh finished!!!"
			;;
		6)
			echo -e "Starting optimizing unused services...\n"
			chkconfig auditd off
			chkconfig postfix off
			chkconfig rhnsd off
			chkconfig rhsmcertd off
			chkconfig avahi-daemon off
			chkconfig messagebus off
			sleep 3
			echo -e "Optimizing unused services finished!!!\n"

			echo -e "Optimizing results...\n"
			echo "Services:"
			chkconfig | grep 3:on
			
			;;	
		7)
			echo "Congratulation, Initialize Linux System finished!!!"
			echo "You can choose restart your computer!!!"
			#接收用户输入
			read -p "Restart(Y/y/N/n):" option
			#如果为Y或者y，那么重启系统
			if [ $option == "Y" ] || [[ $option == "y" ]]
			then
				`shutdown -r now`
			else
				exit 0;
			fi
			exit 0;
			;;
		#其他非法输入打印提示信息
		*)
			echo "Unavailable input, please input in (1-6)"
			;;
	esac
done
