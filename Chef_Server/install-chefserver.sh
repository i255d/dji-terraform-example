#!/bin/bash
#rhel 7
#yum install curl -y
# cd to /tmp
# yum install vim -y 
# vim install-chef-server.sh
# type i for incert
# Highlight all of this code and copy and past in vim text editor
# type escape
# type :wq enter
# chmod +x install-chef-serer.sh
#    ###   EXAMPLE from /tmp directory   ###
# # sudo ./install-chef-server.sh est-chef-config-dev est-chef-config-dev.dev.hdi.local 10.150.0.4

hostname=$1
fqdn=$2
ipaddress=$3
organization='abccsolnm'
companyname='abcc Solutions, Inc.'
username='abccadmin'
usertitle='Chef Admin'
emailaddress='dan.iverson@innovativearchitects.com'
password='@password123'
certfilepathuser='/tmp/drop/abccadmin.pem'
certfilepathorg='/tmp/drop/abccsolnm-validator.pem'
chefinstallpath='/opt/opscode/bin/chef-server-ctl'
chefmgrinstallpath='/usr/bin/chef-manage-ctl'
droppath='/tmp/drop'
downloadpath='/tmp/downloads'
chefinstallversion='chef-server-core-12.19.31-1.el7.x86_64.rpm'
executepath="$downloadpath/$chefinstallversion"
downloadurl='https://packages.chef.io/files/stable/chef-server/12.19.31/el/7/chef-server-core-12.19.31-1.el7.x86_64.rpm'
yellow='\033[0;33m'
cyan='\033[0;96m'  
red='\033[0;31m'
reset='\033[0m'

if [ ! $(hostname -f) == $fqdn ]
then
        echo "$ipaddress         $fqdn           $hostname" >> /etc/hosts
        hostnamectl --static set-hostname $hostname
        systemctl restart systemd-hostnamed
        echo -e "${cyan}hostname set $fqdn${reset}"

else
        hostname -f

fi

# create staging directories
if [ ! -d $droppath  ]
then
        mkdir $droppath
fi

if [ ! -d $downloadpath ]
then
        mkdir $downloadpath
fi

# download the Chef server package
if [ ! -f $executepath ]
then
        echo -e "${cyan}Downloading the Chef server package...${reset}"
        wget -nv -P $downloadpath $downloadurl

fi

#/usr/sbin/iptables
if [ ! -f /tmp/iptables.save ]
then
        #iptables -L -n
        iptables-save > /tmp/iptables.save
        iptables -F
        iptables -S
else
        iptables -S

fi

# install Chef server
if [ ! $(which chef-server-ctl) ]
then
        echo -e "${cyan}Installing Chef server...${reset}"
        rpm -i $executepath
        chef-server-ctl reconfigure

else
        echo -e "${yellow}Output chef-server-ctl path:${reset}"
        which chef-server-ctl  

fi

echo -e "${cyan}Waiting for services...${reset}"
until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

if [ ! $(chef-server-ctl user-list | grep $username)  ]
then
        echo -e "${cyan}Creating initial user and organization...${reset}"
        chef-server-ctl user-create $username $usertitle $emailaddress $password --filename $certfilepathuser
else
        echo -e "${yellow}Output user list:${reset}"
        chef-server-ctl user-list

fi

if [ ! $(chef-server-ctl org-list | grep $organization)  ]
then
        chef-server-ctl org-create $organization $companyname --association_user $username --filename $certfilepathorg
else
        echo -e "${yellow}Output organization list:${reset}"
        chef-server-ctl org-list

fi

COUNTER=0
until [[ -f $certfilepathorg ]] || [[ $COUNTER -ge 10 ]]
do 
        sleep 10s
        let COUNTER+=1
        echo -e "${yellow}The counter is ${red}$COUNTER${reset}"
done

if [ ! -f $chefmgrinstallpath ]
then
        echo -e "${cyan}Installing chef-manager...${reset}"
        chef-server-ctl install chef-manage
        sleep 5s
        chef-server-ctl reconfigure
        sleep 5s 
        chef-manage-ctl reconfigure --accept-license
else
        echo -e "${yellow}Chef Manager installed: ${red}$chefmgrinstallpath${reset}"
fi
