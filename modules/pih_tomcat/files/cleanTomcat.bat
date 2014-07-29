del /F /Q ..\conf\Catalina\localhost\openmrs.xml
rd /S /Q ..\bin\activemq-data
del /F /Q /S ..\logs\*.*
@For /D %%I in (C:\pih\tomcat\temp\*) DO RD /s /q %%I
rd /S /Q ..\webapps\openmrs
rd /S /Q ..\work\Catalina
del /F /Q c:\pih\openmrs\openmrs.log