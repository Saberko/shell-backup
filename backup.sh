#!/bin/bash

backup_path=${HOME}"/backup"

today=$(date +"%Y%m%d%H%M%S")
expireDate=$(date -d -7day +"%Y%m%d%H%M%S")


#数据库用户名密码
mysql_username="root"
mysql_passwd="root"
#需要备份的数据库
db_to_backup=("shoes" "book")

file_name=${today}"-mysql.tar.gz"

echo "backup start..."
echo "checking filepath"
if [ ! -e ${backup_path} ]
then
    echo "backup folder doesn't exist, creating folder..."
    mkdir $backup_path
    echo "created..."
fi

if [ ! -w ${backup_path} ]
then
    chmod -R 777 $backup_path
fi
echo "OK..."

echo "dump mysql..."
cd ${backup_path}
for db in ${db_to_backup[@]}
do
    (mysqldump -u${mysql_username} -p${mysql_passwd} ${db} > ${db}.sql)
done
echo "dump finished"

#下面这两个会出错
#tar cvf ${filename} *.sql
#tar cvf $backup_path/${filename} *.sql

final=$backup_path/${file_name}
echo "compress sql file..."
tar czvf ${final} *.sql
if [ $? == 0 ]
then
    echo "compress successed"
else
    echo "compress failed"
fi

echo -e "delete .sql file"
rm -rf $backup_path/*.sql
echo -e "deleted..."
echo -e 'dump successed...'

#删除七天之前的备份
echo "delete expired backup file..."
rm -rf ${backup_path}/${expireDate}*.sql
echo "deleted..."
