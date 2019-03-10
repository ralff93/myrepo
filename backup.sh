#!/bin/bash
da=`date`
echo "To day is $da"
# Папка, куда будем складывать архивы
syst_dir=/backup/
# Имя сервера, который архивируем
srv_name=ubnt
srv_name2=ubnt.18
# Адрес сервера, который архивируем
srv_ip=192.168.1.88
srv_ip2=192.168.1.40
# Пользователь rsync на сервере, который архивируем
srv_user=backup
# Ресурс на сервере для бэкапа
srv_dir=data
srv_dir2=nginx
srv_dir3=log

echo "Start backup ---------------------${srv_name}----------------------"
# Создаем папку для инкрементных бэкапов
mkdir -p ${syst_dir}${srv_name}/increment/
mkdir -p ${syst_dir}${srv_name}/current/txt/
# Запускаем непосредственно бэкап с параметрами
/usr/bin/rsync -a --delete --password-file=/etc/rsyncd.scrt ${srv_user}@${srv_ip}::${srv_dir} ${syst_dir}${srv_name}/current/txt/ --backup --backup-dir=${syst_dir}${srv_name}/increment/`date +%Y-%m-%d`/txt/
echo "Backup DIR   ---------------------${srv_dir}----------------------"
dat=$(du -hsx /backup/${srv_name}/current | cut -f 1)
echo "size copy - ${dat}"

/usr/bin/rsync -a --delete --password-file=/etc/rsyncd.scrt ${srv_user}@${srv_ip}::${srv_dir2} ${syst_dir}${srv_name}/current/nginx/ --backup --backup-dir=${syst_dir}${srv_name}/increment/`date +%Y-%m-%d`/nginx/
echo "Backup DIR   ---------------------$srv_dir2----------------------"
dat2=$(du -hsx /backup/${srv_name}/current/nginx | cut -f 1)
echo "size copy - ${dat2}"


#UBNT-18

echo "Start backup ---------------------${srv_name2}----------------------"
# Создаем папку для инкрементных бэкапов
mkdir -p ${syst_dir}${srv_name2}/increment/
# Запускаем непосредственно бэкап с параметрами
/usr/bin/rsync -a --delete --password-file=/etc/rsyncd.scrt ${srv_user}@${srv_ip2}::${srv_dir3} ${syst_dir}${srv_name2}/current/ --backup --backup-dir=${syst_dir}${srv_name2}/increment/`date +%Y-%m-%d`/
echo "Backup DIR   ---------------------${srv_dir}----------------------"
dat=$(du -hsx /backup/${srv_name2}/current | cut -f 1)
echo "size copy - ${dat}"

#/usr/bin/rsync -a --delete --password-file=/etc/rsyncd.scrt ${srv_user}@${srv_ip}::${srv_dir2} ${syst_dir}${srv_name}/current/nginx/ --backup --backup-dir=${syst_dir}${srv_name}/increment/nginx/`date +%Y-%m-%d`/
#echo "Backup DIR   ---------------------$srv_dir2----------------------"
#dat2=$(du -hsx /backup/${srv_name}/current/nginx | cut -f 1)
#echo "size copy - ${dat2}"

# Чистим папки с инкрементными архивами старше 30-ти дней
/usr/bin/find ${syst_dir}${srv_name}/increment/ -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;
/usr/bin/find ${syst_dir}${srv_name}/increment/`date +%Y-%m-%d`/nginx/ -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;
/usr/bin/find ${syst_dir}${srv_name2}/increment/ -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;


echo "Finish backu ---------------------${srv_name}----------------------"
date

