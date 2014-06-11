class pih_java {
    
	$pih_java_home = 'c:\pih\java'
	
	file { 'c:\pih\jdk-6u45.zip':
		ensure  => file,
		source	=> "puppet:///modules/pih_java/jdk-6u45.zip",				
	}
	
	file { $pih_java_home:
		ensure  => directory,
		require => File['c:\pih\jdk-6u45.zip'],
	}

	windows::unzip { 'c:\pih\jdk-6u45.zip':
		destination => $pih_java_home,
		creates	=> 'c:\pih\java\bin',
		require => File[$pih_java_home],
	}
}