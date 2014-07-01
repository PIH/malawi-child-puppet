class openmrs {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	
	$pih_openmrs_home = "${pih_home}\\openmrs\\"
	$pih_openmrs_home_linux = regsubst($pih_openmrs_home, '[\\]', '/', G) 
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	$pih_openmrs_db = "${pih_openmrs_home}db\\"
	$pih_openmrs_db_file = "${pih_openmrs_db}openmrs.sql"
	$pih_openmrs_db_bat = "${pih_openmrs_db}dropAndCreateDb.sql"
	$pih_openmrs_db_file_linux = regsubst($pih_openmrs_db_file, '[\\]', '/', G) 
	
	$pih_openmrs_db_zip = "${pih_home_bin}\\openmrs.zip"
	$openmrs_create_db_sql = "${pih_openmrs_db}dropAndCreateDb.sql"
	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')
	
	$pih_openmrs_modules_zip = "${pih_home_bin}\\openmrs-modules.zip"
	$pih_openmrs_war = "${pih_tomcat_home}\\webapps\\openmrs.war"
	$pih_openmrs_runtime_properties = "${pih_openmrs_home}openmrs-runtime.properties"
	
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_db:
		ensure  => directory,
	} ->
	
	file { $pih_openmrs_db_zip:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs.zip",		
	} -> 
	
	windows::unzip { $pih_openmrs_db_zip:
		destination => $pih_openmrs_db,
		creates	=> $pih_openmrs_db_file,
	} -> 
	
	file { $openmrs_create_db_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.sql.erb'),	
	} ->

	exec { 'recreate_openmrs_db': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c mysql.exe -u root -popenmrs < ${openmrs_create_db_sql}",
		logoutput	=> true,
	} ->
	
	exec { 'source_openmrs_db': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c mysql.exe -u root -popenmrs openmrs < ${pih_openmrs_db_file}",
		logoutput	=> true,
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
	
	windows::environment { 'OPENMRS_RUNTIME_PROPERTIES_FILE': 
		value	=>	$pih_openmrs_runtime_properties,
		notify	=> Class['windows::refresh_environment'],
	} -> 
	
	pih_tomcat::start_tomcat { 'openmrs_start_tomcat': 
	
	} 
	
}