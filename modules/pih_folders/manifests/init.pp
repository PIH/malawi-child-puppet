class pih_folders {
	
	file { $pih_home:
		ensure  => directory,
	} -> 
	
	file { $pih_home_bin:
		ensure  => directory,
	} -> 
	
	file { $openmrs_startup_menu:
		ensure  => directory,
	} -> 
	
	windows::shortcut { $start_openmrs_lnk:
	  target      => 'C:\pih\openmrs\startOpenMRS.bat',
	  working_directory	=> 'C:\pih\openmrs', 
	  description => 'Start OpenMRS',
	}
}