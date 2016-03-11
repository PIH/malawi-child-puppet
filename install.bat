cd %CD%
xcopy bin\java\* modules\pih_java\files\ /Y /I
xcopy bin\tomcat\* modules\pih_tomcat\files\ /Y /I
xcopy bin\mysql\* modules\pih_mysql\files\ /Y /I
xcopy bin\putty\* modules\putty\files\ /Y /I
xcopy bin\openmrs\openmrs.sql.zip modules\openmrs\files\ /Y /I
xcopy bin\openmrs\openmrs.war modules\openmrs\files\ /Y /I
xcopy bin\openmrs\modules\*.omod modules\openmrs\files\modules\ /Y /I
puppet apply --verbose --logdest=console --hiera_config=./hiera.yaml --modulepath=./modules manifests\site.pp