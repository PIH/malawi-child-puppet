class openmrs {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	require gzip 
	require putty 
	
	$mysql_exe = "${pih_mysql_home}\\bin\\mysql.exe"
	$pih_openmrs_home_linux = regsubst($pih_openmrs_home, '[\\]', '/', G) 
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	$pih_openmrs_db = "${pih_openmrs_home}db\\"
	$pih_openmrs_db_file = "${pih_openmrs_db}openmrs.sql"
	$pih_openmrs_db_bat = "${pih_openmrs_db}dropAndCreateDb.sql"
	$pih_openmrs_db_file_linux = regsubst($pih_openmrs_db_file, '[\\]', '/', G) 
	
	$openmrs_create_db_sql = "${pih_openmrs_db}dropAndCreateDb.sql"
	
	$stop_OpenMRS_bat = "${pih_openmrs_home}stopOpenMRS.bat"
	$start_OpenMRS_bat = "${pih_openmrs_home}startOpenMRS.bat"
	$label_shutdown_openmrs = hiera('label_shutdown_openmrs')
	$shutdown_openmrs_lnk = "${openmrs_startup_menu}\\Shutdown OpenMRS.lnk"
	$label_start_openmrs = hiera('label_start_openmrs')
	$start_openmrs_lnk = "${openmrs_startup_menu}\\Start OpenMRS.lnk"
	
	$mysql_root_user = hiera('mysql_root_user')
	$mysql_root_password = hiera('mysql_root_password')
	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')	
	
	$parent_mysql_db_password = hiera('parent_mysql_db_password')
	$ssh_parent_address = hiera('ssh_parent_address')
	$ssh_user = hiera('ssh_user')
	$ssh_port = hiera('ssh_port')
	$ssh_key = "${pih_putty_home}\\id_rsa"
	$plink_exe = "${pih_putty_home}\\PLINK.EXE"
	$pscp_exe = "${pih_putty_home}\\PSCP.EXE"
	$gzip_exe = "${pih_gzip_home}\\bin\\gzip"
	
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

	file { $pih_openmrs_modules:
		ensure  => directory,
	} ->
	
	file { $openmrs_create_db_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.sql.erb'),	
	} ->
	
	file { $stop_OpenMRS_bat: 
		ensure  => present,
		provider => windows, 	
		source	=> "puppet:///modules/openmrs/stopOpenMRS.bat",
	} ->  

	windows::shortcut { $shutdown_openmrs_lnk:
	  target      => $stop_OpenMRS_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_shutdown_openmrs}",
	} ->	

	file { $start_OpenMRS_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/startOpenMRS.bat.erb'),	
	} -> 
	
	windows::shortcut { $start_openmrs_lnk:
	  target      => $start_OpenMRS_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_start_openmrs}",
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
	}

}