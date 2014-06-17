if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

$pih_home = 'c:\pih'
$pih_java_home = "${pih_home}\\java"
$pih_tomcat_home = "${pih_home}\\tomcat"
	
node default {
	
	include pih_java
	include pih_tomcat
	include pih_mysql
}