mysql -u root -popenmrs -e "show databases;"
GRANT ALL ON openmrs.* TO openmrs@localhost IDENTIFIED BY 'openmrs';
update mysql.user set password=PASSWORD("openmrs") where User='root';
flush privileges;


update mysql.user set password=PASSWORD("openmrs") where User='root';
flush privileges;