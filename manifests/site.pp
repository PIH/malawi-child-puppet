if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

node default {
		
	include pih_java
}