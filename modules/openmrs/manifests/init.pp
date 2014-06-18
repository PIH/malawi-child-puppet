class openmrs {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	
	$pih_openmrs_home = "${pih_home}\\openmrs\\"
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	
	$pih_openmrs_modules_zip = "${pih_home}\\openmrs-modules.zip"
	
	
	
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_modules_zip:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs-modules.zip",		
	} -> 
	
	windows::unzip { $pih_openmrs_modules_zip:
		destination => $pih_openmrs_home,
		creates	=> $pih_openmrs_modules,
	} 
	
}