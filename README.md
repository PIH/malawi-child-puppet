malawi-child-puppet
===================

puppet script that installs and configures a Windows based sync child server

puppet apply --verbose --logdest=console --modulepath=./modules manifests\site.pp



Installing a PIH-EMR Mental Health Instance
===========================================

Prepping the Flash Drive
------------------------

1) Checkout master branch and copy to a flash drive in a new top-level directory c:\mental-health

2) Log on to amigo.pih-emr.org and download "/home/backups/binaries/mental-health/hieradata/common.yawl"
    Copy this common.yawl over to the flash drive, replacing the default one in hieradata/common.yawl

3) Also from amigo.pih-emr.org download "/home/backups/binaries/mental-health/bin/*"
    Create a new directory on the flash drive, "c:\mental-health\bin" and copy over the contents of the directory downloaded in the previous step

4) Copy the MH "gold" version of OpenMRS core and modules you wish to install into "c:\mental-health\bin\openmrs" and "c:\mental-health\bin\openmrs\modules" replacing the existing
    You can find these on the Bamboo server at: "/home/emradmin/mental-health/deployment/"
    (if necessary, promote the latest PIH-EMR unstable deploy to Mental Health by running the "promote latest to mental health" bamboo build project)


Installing from the Flash Drive
-------------------------------

1) Log on as the local admin account (e.g. PIH Windows user)

2)Copy from the USB the entire mental-health folder to c:\

3) Install puppet
    Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    cd c:\mental-health
    Type installPuppet.bat (this includes now installing Window Resource Kit Tools too)
    If a dialog box says there are compatibility issues, allow the install to continue. Use the defaults and agree to the license agreement.
    Close any Command.exe windows that are already opened
    Ensure puppet installed okay: Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    Type: puppet --version. It should say something like 3.6.2
    Type: facter. It should list a bunch of information
    If either of these checks fail, you need to quit the installation

3) Ensure you are using the correct configuration file
    Navigate to c:\mental-health\hieradata\
    Open notepad and then open this file: c:\mental-health\hieradata\common.yaml
    If the file doesn't display correctly you may need to install Notepad++
    Change the windows_openmrs_user to the Local Admin user that is logged on, e.g. PIH (to ensure you have the correct username, you can type whoami on the command line)

4) Install OpenMRS
    Close all existing command prompts
    Open a new command prompt (go to start and type cmd and right click on cmd.exe and choose to "Run as Administrator")
    Type cd c:\mental-health\
    Type: install.bat
    If the install.bat outputs any red messages please stop and debug. Do not continue to the next step.
    After waiting couple minutes OpenMRS should have started automatically
    (You could click on Start Menu->Windows->All Programs->OpenMRS->Start OpenMRS and wait until OpenMRS starts)

5) Verify OpenMRS has been installed
    Open a browser window and navigate to http://localhost:8080/openmrs
    Make sure you are able to log on the OpenMRS with the "admin" user and provided and password

6) Create a link to http://localhost:8080/openmrs on the desktop (labelling it "OpenMRS Santè Mentale")
    TODO: document how to create a shortcut?

7) Update OpenMRS software
    Click Windows->All Programs->OpenMRS->Check for OpenMRS updates
    When run for the first time all *.omod and war files are downloaded
    When prompted type "Y" to install the updates

8) Confirm local identifier pool has identifiers in it
    Log in to OpenMRS
    (The refill task only runs every 5 minutes, so it may not immediately have identifiers, but after 5 minutes it should).
    Go to: http://localhost:8080/openmrs/module/idgen/manageIdentifierSources.list
    Click "View" next to local pool of identifiers
    Confirm that "Quantity Available" > 0 (there should be 1000 identifiers, I believe)
