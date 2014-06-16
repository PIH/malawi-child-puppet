class pih_tomcat {
    
	$pih_tomcat_zip = "${pih_home}\\tomcat-6.0.32.zip"
	$pih_install_tomcat = "${pih_tomcat_home}\\bin\\install_tomcat.bat"
	
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
		notify	=> Class['windows::refresh_environment'],
	}  -> 
	
	file { $pih_install_tomcat: 
		ensure  => present,
		content	=> template('pih_tomcat/install_tomcat.erb'),	
		notify	=> Exec['install_tomcat'],
	} 
	
	exec { 'install_tomcat': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		command		=> 'cmd.exe /c install_tomcat.bat',
		logoutput	=> true,
	} -> 
	
	exec { 'start_tomcat': 
		path		=> $::path,
		command		=> 'cmd.exe /c sc start Tomcat6',
		logoutput	=> true,
	}
	
	
}