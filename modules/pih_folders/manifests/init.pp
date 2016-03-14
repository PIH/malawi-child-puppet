class pih_folders {
	
	$label_reset_openmrs = "Reset OpenMRS"
	$reset_openmrs_lnk = "${openmrs_startup_menu}\\Reset OpenMRS.lnk"
	$install_bat = "${puppet_install_home}\\install.bat"

	file { $pih_home:
		ensure  => directory,
	} -> 
	
	file { $pih_home_bin:
		ensure  => directory,
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
	} 
	
}