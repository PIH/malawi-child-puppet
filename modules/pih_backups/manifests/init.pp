class pih_backups {
    
	require pih_mysql
	require openmrs
	
	
	$za_exe = '7za.exe'
	$za_exe_bin = "${pih_home_bin}\\${za_exe}"
	$mysql_backup_bat = 'mysqbackup.bat'
	$mysql_backup_bat_bin = "${pih_home_bin}\\${mysql_backup_bat}"
	$pih_backups_home = "${pih_home}\\backups"

	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')	
	
	file { $pih_backups_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $za_exe_bin:
		ensure  => file,
		source	=> "puppet:///modules/pih_backups/${za_exe}",		
		require => File[$pih_backups_home],
	} ->
	
	file { $mysql_backup_bat_bin:
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_backups/mysqlbackup.bat.erb'),	
	} ->
	
	windows::path { "${pih_backups_home}": } 

}