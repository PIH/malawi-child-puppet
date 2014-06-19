class pih_folders {
	
	file { $pih_home:
		ensure  => directory,
	} -> 
	
	file { $pih_home_bin:
		ensure  => directory,
	}
}