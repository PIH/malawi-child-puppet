class pih_update {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	require gzip 
	require putty 
	
	$pih_update_home = "${pih_home}\\update\\"
	$pih_openmrs_update_bat = "${pih_update_home}update-openmrs.bat"
	
	$ssh_parent_address = hiera('ssh_parent_address')
	$ssh_user = hiera('ssh_user')
	$ssh_port = hiera('ssh_port')
	$ssh_key = "${pih_putty_home}\\id_rsa"
	$pscp_exe = "${pih_putty_home}\\PSCP.EXE"
	
	
	file { $pih_update_home:
		ensure  => directory,
	} -> 
	
	file { $pih_openmrs_update_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_update/update-openmrs.bat.erb'),	
	} 
}