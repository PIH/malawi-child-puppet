class pih_tomcat {
    
	$pih_tomcat_zip = "${pih_home}\\tomcat-6.0.32.zip"
	
	file { $pih_tomcat_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_tomcat_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_tomcat/tomcat-6.0.32.zip",		
		require => File[$pih_tomcat_home],
	}
	
	windows::unzip { $pih_tomcat_zip:
		destination => $pih_tomcat_home,
		creates	=> "${pih_tomcat_home}\\bin",
		require => File[$pih_tomcat_home],
	} ->
	
	windows::environment { 'CATALINA_HOME': 
		value	=>	$pih_tomcat_home,
		require => File[$pih_tomcat_home],
	}
}