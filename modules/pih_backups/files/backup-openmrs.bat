@echo off

echo.
echo Backing up OpenMRS software

set PIH_HOME=c:\pih
set PIH_UPDATE_HOME=%PIH_HOME%\update
set PIH_TOMCAT_HOME=%PIH_HOME%\tomcat
set PIH_OPENMRS_HOME=%PIH_HOME%\openmrs\
set MYSQL_HOME=%PIH_HOME%\mysql
set MYSQL_PASSWORD=ROOT_PASSWORD

mkdir %PIH_UPDATE_HOME%\backup
mkdir %PIH_UPDATE_HOME%\backup\db
mkdir %PIH_UPDATE_HOME%\backup\modules
mkdir %PIH_UPDATE_HOME%\backup\configuration

del /F /Q /S %PIH_UPDATE_HOME%\backup\db\openmrs.sql
%MYSQL_HOME%\bin\mysqldump.exe -e -uroot -p%MYSQL_PASSWORD% openmrs > %PIH_UPDATE_HOME%\backup\db\openmrs.sql

del /F /Q /S %PIH_UPDATE_HOME%\backup\modules\*.*
del /F /Q /S %PIH_UPDATE_HOME%\backup\configuration\*.*
del /F /Q /S %PIH_UPDATE_HOME%\backup\openmrs.war

xcopy %PIH_HOME%\openmrs\modules\* %PIH_UPDATE_HOME%\backup\modules\ /Y /I
xcopy %PIH_HOME%\openmrs\configuration\* %PIH_UPDATE_HOME%\backup\configuration\ /Y /I /E /H /C
xcopy %PIH_TOMCAT_HOME%\webapps\openmrs.war %PIH_UPDATE_HOME%\backup\ /Y /I
