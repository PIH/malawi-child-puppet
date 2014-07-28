class openmrs {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	require putty 
	
	$pih_openmrs_home = "${pih_home}\\openmrs\\"
	$mysql_exe = "${pih_mysql_home}\\bin\\mysql.exe"
	$pih_openmrs_home_linux = regsubst($pih_openmrs_home, '[\\]', '/', G) 
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	$pih_openmrs_db = "${pih_openmrs_home}db\\"
	$pih_openmrs_db_file = "${pih_openmrs_db}openmrs.sql"
	$pih_openmrs_db_bat = "${pih_openmrs_db}dropAndCreateDb.sql"
	$pih_openmrs_db_file_linux = regsubst($pih_openmrs_db_file, '[\\]', '/', G) 
	
	$openmrs_create_db_sql = "${pih_openmrs_db}dropAndCreateDb.sql"
	$delete_sync_tables_sql = "${pih_openmrs_db}deleteSyncTables.sql"
	$get_db_from_parent_bat = "${pih_openmrs_db}getDbFromParent.bat"
	$update_child_server_settings_sql = "${pih_openmrs_db}updateChildServerSettings.sql"
	$update_parent_server_settings_sql = "${pih_openmrs_db}updateParentServerSettings.sql"
	
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
	
	$child_name = hiera('child_name')
	$sync_admin_email = hiera('sync_admin_email')
	$sync_parent_name = hiera('sync_parent_name')
	$sync_parent_address = hiera('sync_parent_address')
	$sync_parent_uuid = hiera('sync_parent_uuid')
	$sync_parent_user_name = hiera('sync_parent_user_name')
	$sync_parent_user_password = hiera('sync_parent_user_password')
	
	$server_uuid_text_file = "${pih_openmrs_db}${child_name}-serveruuid.txt"
	$output_server_uuid = regsubst($server_uuid_text_file, '[\\]', '/', G)
	$uploaded_child_server_uuid = "/tmp/${child_name}-serveruuid.txt"
	
	notify{"The value of uploaded_child_server_uuid is ${uploaded_child_server_uuid}": }
	
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_db:
		ensure  => directory,
	} ->
	
	file { $openmrs_create_db_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.sql.erb'),	
	} ->
	
	file { $delete_sync_tables_sql: 
		ensure  => present,
		provider => windows, 	
		source	=> "puppet:///modules/openmrs/deleteSyncTables.sql",
	} 

	file { $update_child_server_settings_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/updateChildServerSettings.sql.erb'),	
	} ->
	
	file { $update_parent_server_settings_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/updateParentServerSettings.sql.erb'),		
	} ->
	
	file { $get_db_from_parent_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/getDbFromParent.bat.erb'),	
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

	exec { 'execute_get_parent_db': 
		path		=> $::path,
		cwd			=> "${pih_openmrs_db}", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c ${get_db_from_parent_bat}",
		logoutput	=> true,
		
	}

}