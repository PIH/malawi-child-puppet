class pih_folders {
	
	$label_reset_openmrs = "Reset OpenMRS"
	$reset_openmrs_lnk = "${openmrs_startup_menu}\\Reset OpenMRS.lnk"
	$install_bat = "${puppet_install_home}\\install.bat"
	$pih_icon = "${pih_home_bin}\\pih_favicon.ico"

	file { $pih_home:
		ensure  => directory,
	} -> 
	
	file { $pih_home_bin:
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
	} -> 
	
	file { $pih_icon:
		ensure  => file,
		source	=> "puppet:///modules/pih_folders/PIH_favicon_50px.ico",		
		require => File[$pih_home_bin],
	} -> 
	
	exec { 'remove_openmrs_startup_menu': 
		path		=> $::path,
		provider	=> windows, 
		command		=> "cmd.exe /c rd /S /Q ${openmrs_startup_menu}",
		onlyif		=> "cmd.exe /c dir ${openmrs_startup_menu}",
		logoutput	=> true,
	} -> 
	
	file { $openmrs_startup_menu:
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
	} 
	
}