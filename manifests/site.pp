if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

$pih_home = hiera('pih_home')
$pih_home_bin = "${pih_home}\\bin"
$pih_java_home = "${pih_home}\\java"
$pih_tomcat_home = "${pih_home}\\tomcat"
$pih_mysql_home = "${pih_home}\\mysql"
	
node default {
	include pih_folders
	include pih_java
	include pih_tomcat
	include pih_mysql
	include openmrs 
}