if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

$pih_home = 'c:\pih'
$pih_java_home = "${pih_home}\\java"
	
node default {
	
	include pih_java
}