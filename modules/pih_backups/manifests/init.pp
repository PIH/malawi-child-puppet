class pih_backups {
    
	$za_exe = '7za.exe'
	$za_exe_bin = "${pih_home_bin}\\${za_exe}"
	$pih_backups_home = "${pih_home}\\backups"
	
	file { $pih_backups_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $za_exe_bin:
		ensure  => file,
		source	=> "puppet:///modules/pih_backups/${za_exe}",		
		require => File[$pih_backups_home],
	} ->
	
	
	windows::path { "${pih_backups_home}": } 

}