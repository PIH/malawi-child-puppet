class pih_java {
    
	$pih_home = 'c:\pih'
	$pih_java_home = "${pih_home}\\java"
	$pih_java_zip = "${pih_home}\\jdk-6u45.zip"
	
	file { $pih_home:
		ensure  => directory,
	}
	file { $pih_java_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_java_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_java/jdk-6u45.zip",		
		require => File[$pih_java_home],
	}
	
	windows::unzip { $pih_java_zip:
		destination => $pih_java_home,
		creates	=> "${pih_java_home}\\bin",
		require => File[$pih_java_home],
	}
	
	windows::environment { 'JAVA_HOME': 
		value	=>	$pih_java_home,
		require => File[$pih_java_home],
	}
}