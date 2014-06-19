class openmrs {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	
	$pih_openmrs_home = "${pih_home}\\openmrs\\"
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	$pih_openmrs_db = "${pih_openmrs_home}\\db\\"
	
	$pih_openmrs_db_zip = "${pih_home_bin}\\openmrs.sql.zip"
	$openmrs_create_db_bat = "${pih_openmrs_db}\\dropAndCreateDb.sql"
	
	$pih_openmrs_modules_zip = "${pih_home_bin}\\openmrs-modules.zip"
	$pih_openmrs_war = "${pih_tomcat_home}\\webapps\\openmrs.war"
	$pih_openmrs_runtime_properties = "${pih_tomcat_home}\\bin\\openmrs-runtime.properties"
	
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_db_zip:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs.sql.zip",		
	} -> 
	
	windows::unzip { $pih_openmrs_db_zip:
		destination => $pih_openmrs_db,
		creates	=> $pih_openmrs_db,
	} -> 
	
	file { $openmrs_create_db_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.sql.erb'),	
	} ->
	
	file { $pih_openmrs_modules_zip:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs-modules.zip",		
	} -> 
	
	windows::unzip { $pih_openmrs_modules_zip:
		destination => $pih_openmrs_home,
		creates	=> $pih_openmrs_modules,
	} -> 
	
	file { $pih_openmrs_war:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs.war",		
	} -> 
	
	file { $pih_openmrs_runtime_properties: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/openmrs-runtime.properties.erb'),	
	} -> 
	
	pih_tomcat::start_tomcat { 'openmrs_start_tomcat': 
	
	} 
	
}