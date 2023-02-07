#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

echo -n -e "\nIf you know the current user's password, type here: "
read passwd

echo -e "\n${ORANGE}[+]Checking if you are in docker...${NC}\n"
isin_docker=$(find / -name '.dockerenv' 2>/dev/null)
if [[ -z "$isin_docker" ]]; then
    echo -e "I think I'm not in docker."
else
    echo -e "Found .dockerenv file. I might be in docker."
fi

echo -e "\n${ORANGE}[+]Checking your id...${NC}\n"
id

echo -e "\n${ORANGE}[+]Getting kernel info...${NC}\n"
uname -a

echo -e "\n${ORANGE}[+]Getting hostname info...${NC}\n"
hostnamectl

echo -e "\n${ORANGE}[+]Getting sudo version...${NC}\n"
sudo -V | grep "Sudo version" | cut -d " " -f 3

echo -e "\n${ORANGE}[+]Checking ip address...${NC}\n"
(ifconfig || ip a) 2>/dev/null

echo -e "\n${ORANGE}[+]Finding SUID files...${NC}\n"
find / -perm -u=s -type f 2>/dev/null

echo -e "\n${ORANGE}[+]Checking network services running on the machine...${NC}\n"
(netstat -punta || ss --ntpu) | grep "127.0"

echo -e "\n${ORANGE}[+]Listing users with console...${NC}\n"
cat /etc/passwd | grep "sh$"

echo -e "\n${ORANGE}[+]Checking path variable...${NC}\n"
echo $PATH

echo -e "\n${ORANGE}[+]Checking if AppArmor exsits...${NC}\n"
if [ `which aa-status 2>/dev/null` ]; then
    aa-status
  elif [ `which apparmor_status 2>/dev/null` ]; then
    apparmor_status
  elif [ `ls -d /etc/apparmor* 2>/dev/null` ]; then
    ls -d /etc/apparmor*
  else
    echo "Not found AppArmor"
fi

echo -e "\n${ORANGE}[+]Checking history...${NC}\n"
cat ~/.bash_history

echo -e "\n${ORANGE}[+]Finding in-memory passwords...${NC}\n"
in_memory=$(strings /dev/mem -n10 2>/dev/null| grep -i PASS)
if [[ -z "$in_memory" ]]; then
    echo -e "Can't find it"
else
    echo -e "$in_memory"
fi

echo -e "\n${ORANGE}[+]Checking useful binaries...${NC}\n"
which nmap aws nc ncat netcat nc.traditional wget curl ping gcc g++ make gdb base64 socat python python2 python3 python2.7 python2.6 python3.6 python3.7 perl php ruby xterm doas sudo fetch docker lxc ctr runc rkt kubectl 2>/dev/null

echo -e "\n${ORANGE}[+]Finding hidden files in home directory...${NC}\n"
find / -type f -iname ".*" -ls 2>/dev/null | grep /home/
 
echo -e "\n${ORANGE}[+]Finding writable folder...${NC}\n"
find / -type d -writable 2>/dev/null

echo -e "\n${ORANGE}[+]Finding files owned by root, readable by me but not world readable...${NC}\n"
VAR_FOLDER="/var"
PROC_FOLDER="/proc"
RUN_FOLDER="/run"
SYS_FOLDER="/sys"
FOLDER="/"

files=$(find / -type f -user root ! -perm -o=r 2>/dev/null)
for file in $files
do
if [[ "$file" != "$VAR_FOLDER"* && "$file" != "$PROC_FOLDER"* && "$file" != "$RUN_FOLDER"* && "$file" != "$SYS_FOLDER"* && "$file" == "$FOLDER"* ]];then
echo $file
fi
done

echo -e "\n${ORANGE}[+]Opening /etc/crontab...${NC}\n"
cat /etc/crontab

echo -e "\n${ORANGE}[+]Checking crontab...${NC}\n"
crontab=$(crontab -l)
echo "$crontab"
echo -e "[*]You may want to run pspy"
echo -e "https://github.com/DominicBreuker/pspy"

echo -e "\n${ORANGE}[+]Finding id_rsa...${NC}\n"
id_rsa=$(find / -name id_rsa 2> /dev/null)
if [[ -z "$id_rsa" ]]; then
    echo -e "Can't find any ssh private key"
else
    echo -e "$id_rsa"
fi

echo -e "\n${ORANGE}[+]Finding softwares in opt directory...${NC}\n"
ls -la /opt/

echo -e "\n${ORANGE}[+]Opening /etc/exports...${NC}\n"
cat /etc/exports

echo -e "\n${ORANGE}[+]Checking motd files...${NC}\n"
for file in /etc/update-motd.d/*
do
if [[ -f $file && -r $file ]]; then
    echo "----------$file----------"
    cat $file
fi
done

echo -e "\n${ORANGE}[+]Listing /dev/shm. If you find somehting, that might be trace of rootkits...${NC}\n"
ls -la /dev/shm

echo -e "\n${ORANGE}[+]Checking commands you can execute with sudo...${NC}\n"
sudo_l=$(echo "$passwd" | sudo -l -S 2>/dev/null)
if [[ -z "$sudo_l" ]]; then
    echo -e "This user may not run any commands with sudo or you gave me a wrong passoword"
else
   echo -e "$sudo_l"
fi

echo -e "\n${ORANGE}[+]Checking if /etc/shadow is readable...${NC}\n"
ls -l /etc/shadow
if [[ -r /etc/shadow ]]; then
    echo -e "\n/etc/shadow is readable"
else 
    echo -e "\n/etc/shadow is NOT readable"
fi

echo -e "\n${ORANGE}[+]Checking if /etc/passwd is writable...${NC}\n"
ls -l /etc/passwd
if [[ -w /etc/passwd ]]; then
    echo -e "\n}/etc/passwd is writable"
else 
    echo -e "\n/etc/passwd is NOT writable"
fi

echo -e "\n${ORANGE}[+]Checking if /etc/sudoers is writable...${NC}\n"
ls -l /etc/sudoers
if [[ -w /etc/sudoers ]]; then
    echo -e "\n/etc/sudoers is writable"
else 
    echo -e "\n/etc/sudoers is NOT writable"
fi

echo -e "\n${ORANGE}[+]Finding files with bak extension in /var/backups directory...${NC}\n"
bak=$(ls -la /var/backups | grep .bak)
if [[ -z "$bak" ]]; then
    echo -e "Can't find it."
else
    echo -e "$bak"
fi

echo -e "\n[+]Scanning is done. Good Luck :)\n"
