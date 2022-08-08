malawi-child-puppet
===================

puppet script that installs and configures a Windows based sync child server

puppet apply --verbose --logdest=console --modulepath=./modules manifests\site.pp



Installing a PIH-EMR Mental Health Instance
===========================================

Prepping the Flash Drive
------------------------
\* Install [Git for Windows](https://git-scm.com/download/win)\* and [Notepad++](https://notepad-plus-plus.org/) 

1) Checkout master branch of this module and copy to a flash drive in a new top-level directory /mental-health:
```
Open Git Bash 
cd /c/ 
git clone https://github.com/PIH/malawi-child-puppet.git mental-health
```

2) SFTP to amigo.pih-emr.org and download "/home/backups/binaries/mental-health/hieradata/common.yaml"
    Copy this common.yaml over to the flash drive, replacing the default one in hieradata/common.yaml

```
cd mental-health/hieradata
scp USER_NAME@amigo.pih-emr.org:/home/backups/binaries/mental-health/hieradata/common.yaml .
```

3) Also from amigo.pih-emr.org download "/home/backups/binaries/mental-health/bin/*" and the configuration files "/home/backups/binaries/mental-health/openmrs-config-zl.zip"  (you can fetch an entire directory structure using sftp using "get -r", or you may want to zip up the entire bin directory first)
    Create a new directory on the flash drive, "/mental-health/bin" and copy over the contents of the directory downloaded in the previous step
   
```  
cd ..
scp -r USER_NAME@amigo.pih-emr.org:/home/backups/binaries/mental-health/bin .
```
4) Copy the MH "gold" version of OpenMRS core and modules you wish to install into "/mental-health/bin/openmrs" and "/mental-health/bin/openmrs/modules" replacing the existing war and omods
    NOTE: do **not** replace the base sql file (openmrs.sql.zip) found in the /mental-health/bin/openmrs directory (which you downloaded in step #3)
    You can find these on the Bamboo server at: "/home/emradmin/mental-health/deployment/"
    (if necessary, promote the latest PIH-EMR unstable deploy to Mental Health by running the "promote latest to mental health" bamboo build project)
     Note: IP should be the url or ip-address for the bamboo server.

```
cd /c/mental-health/bin/openmrs
scp USER_NAME@IP:/home/emradmin/mental-health/deployment/openmrs.war .
scp -r USER_NAME@IP:/home/emradmin/mental-health/deployment/modules .
```

Installing from the Flash Drive
-------------------------------

Prerequiste--Internet connectivity will be required, in particular for steps #6 & #7

0) Close all applications and reboot the machine

1) Log on as the local admin account (e.g. PIH Windows user)

2) Copy from the USB the entire mental-health folder to c:\

3) Install puppet
    Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    cd c:\mental-health
    Type installPuppet.bat (this includes now installing Window Resource Kit Tools too)
    If a dialog box says there are compatibility issues, allow the install to continue ("Run Program"). 
    Use the defaults and agree to the license agreement.
    Close any Command.exe windows that are already opened
    Ensure puppet installed okay: Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    Type: "puppet --version" It should say something like 3.6.2
    Type: "facter" It should list a bunch of information
    If either of these checks fail, you need to quit the installation
    Type: "whoami"  Note the username (the value after the "\" )

4) Ensure you are using the correct configuration file
    Open Notepad and then open this file: c:\mental-health\hieradata\common.yaml
    (If the file doesn't display correctly you may need to install Notepad++)
    Change the windows_openmrs_user to the name of the Local Admin user that is logged on (the value you recorded at the end of Step 3)
    Save the changes to the file

5) Install OpenMRS
    Close all existing command prompts
    Open a new command prompt (go to start and type cmd and right click on cmd.exe and choose to "Run as Administrator")
    Type cd c:\mental-health\
    Type: install.bat (Note: When upgrading an existing laptop, delete all the contents found in C:\openmrs\openmrs\configuration before running install.bat)
    **This command will take several minutes to run**
    If the install.bat outputs any red messages please stop and debug. Do not continue to the next step.
    Wait until the script finishes (it will display a line like "Notice: Finished catalog run in 346.20 seconds")
     
6) Verify OpenMRS has been installed

   **Note:** This step is important and should always be run after running install.bat. For the configuration files to be copied over,
      navigate to <drive_name>/openmrs/update then run (click on) update-openmrs bat file. At once point you will be prompted to agree input Y and press enter   
   **After execution is complete, wait 10 minutes to allow OpenMRS to start up for the first time**
    Click on newly-created desktop shortcut "OpenMRS Sante Mentale"  (the browser will show the page as "connecting" until OpenMRS starts up)
    Make sure you are able to log on the OpenMRS with the "admin" user and **provided password**
   
   **Note:** If installing for the first time, if OpenMRS starts up and is asking for an administrator password to continue with setup, and you
   are unable to login, then Stop OpenMRS, modify the file at c:\openmrs\openmrs\openmrs-runtime.properties and set auto_update_database=true,
   and then Start OpenMRS.
   
   **Note:** If you are unsure how to log in as the admin user, check the openmrs-runtime.properties file for the scheduler username and password.

7) Confirm local identifier pool has picked up identifiers from the remote identifier source
    (The refill task only runs every 5 minutes, so it may not immediately have identifiers, but **after 5 minutes with Internet connectivity** it should).
    Log in to OpenMRS as the Admin user
    Go to: http://localhost:8080/openmrs/module/idgen/manageIdentifierSources.list
    Click "Voir" next to "Local Pool of ZL Identifiers"
    Confirm that "Quantity Available" is greater than 0 (there should be 1000 identifiers, I believe)

8) Update OpenMRS software
    Windows->All Programs->OpenMRS->Check for OpenMRS updates, right click, run as Administrator
    When run for the first time all *.omod and war files are downloaded
    When prompted type "Y" to install the updates
    
9) Schedule Daily Backups 
    Windows->All Programs->OpenMRS->Schedule OpenMRS backups, right click, run as Administrator
   
10) Add new user account(s) as necessary
    Log back into OpenMRS (it will take a few minutes for it to come up again if it installed updates in step #7)
    From the Home Page:
    Administration système -> Gérer les comptes -> Créer un compte
    Enter First and Last Name and Gender
    Click on  Créer un compte utilisateur
    Enter username and password
    Niveau de privilège = Plein
    Langue par défaut = User's choice of Language
    Standard user should have the following Capacités:
    - Privilèges d'archiviste/commis
    - Privilèges du psychologue
    - Privilèges MEQ
    Type de prestataire is most likely Psychologue


Setting Up a New Laptop with an Existing Mental Health Database
----------------------------------------------------------------

TODO: flesh out the details and test on a Windows machine

1) Follow all the above steps for "Installing from the Flash Drive", with the exception of #7 and #10, which are unnecessary
    (If you do perform steps 7 and 10, no harm will occur, but when you source the new database, those changes will be overwritten)

2) From the existing laptop, dump the database and copy it to a flash drive:
    From the command line run "mysqldump -u root -p openmrs > openmrs.sql"
    
3) Copy the the database dump to the new laptop and source it:
    Stop OpenMRS (TODO: is there a link for this?)
    Log into mysql client and create the new database "create database openmrs default charset UTF-8"
    From the command line, source the database "mysql -u root -p openmrs < openmrs.sql"

Staging a new PIH-EMR Mental Health Instance for Release
===========================================================================

Currently, the latest "gold" code and config releases for Mental Health are hosted on our old Bamboo server
(bamboo.pih-emr.org)

Ideally, we will be moving away from this server, but we need to use it in the short-term because  the
scripts on the mental health laptops are currently configured to look to Bamboo for updates.

Previously, we had Bamboo jobs to install the latest code and config for Mental Health into the appropriate directories.
(For reference, I'm posted the scripts those jobs executed here: https://pihemr.atlassian.net/browse/UHM-6617)

However, as we are "sunsetting" the old Bamboo service, for now we will manually install the files on the old Bamboo
server when needed.

I've written the following instructions based on our previous scripts and partially tested, but not
fully tested, as I didn't want to touch the existing setup on Bamboo.  The first time we try the following we
should use care.

Staging the contents of the OpenMRS Debian package (ie, the code)
-----------------------------------------------------------------

1) On Bamboo, Clean out the existing war, omod and temp directory set up on Bamboo:

```
rm /home/emradmin/mental-health/deployment/openmrs.war
rm /home/emradmin/mental-health/deployment/modules/*
rm -r /home/emradmin/mental-health/deployment/tmp/*
```

2) Find the version of the PIH EMR debian package you wish to deploy here: https://openmrs.jfrog.io/ui/native/deb-pih/pool/

3) Download this debian package to Bamboo and place it in the  temp directory `/home/emradmin/mental-health/deployment/tmp`
   (todo: I tried to fetch via wget but it wasn't working correctly, not sure if I had some sort of typo)

5) Extract the debian package and copy the war and modules into the appropriate directories

```
dpkg-deb -x *.deb .

mv home/tomcat7/.OpenMRS/modules/* /home/emradmin/mental-health/deployment/modules
mv var/lib/tomcat7/webapps/openmrs.war /home/emradmin/mental-health/deployment
```

5) Clean out the temp directory

```
rm -r /home/emradmin/mental-health/deployment/tmp/*
```

NOTE: looks like we are *not* currently staging the OWAs or the new O3 frontend code for deployment to the MH laptops.
If we ever want to use this functionality on the MH laptops, we will need to make sure we start deploying this.


Staging the contents of the ZL config
-----------------------------------------------------------------

1) Clean out the existing "configuration" directory in the staging directory on Bamboo:

```
rm -rf /home/emradmin/mental-health/deployment/configuration/*
```

2) Go to that directory and use wget to fetch the version of the config-zl you want to use from Sonatype

```
cd /home/emradmin/mental-health/deployment/configuration
# replace "1.13.0" with the version you want to download
wget -O openmrs-config-zl.zip "https://oss.sonatype.org/service/local/artifact/maven/content?g=org.pih.openmrs&a=openmrs-config-zl&r=releases&p=zip&v=1.13.0"
```

3) Unzip the archive

```
unzip openmrs-config-zl.zip
```

4) Make sure zip file is also staged in the directory `/home/emradmin/mental-health` directory
   (I believe it's staged here so that it can be updated by clients without having to update the code)
```
rm -rf ../../openmrs-config-zl.zip
mv openmrs-config-zl.zip ../../
```

