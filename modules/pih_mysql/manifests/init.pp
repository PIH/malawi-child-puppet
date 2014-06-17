class pih_mysql {
    
	$pih_mysql_zip = "${pih_home}\\mysql-5.6.16-win32-min.zip"
	$pih_mysql_home = "${pih_home}\\mysql\\"
	$pih_mysql_ini = "${pih_home}\\mysql\\my.ini"
	$pih_mysql_data = "${pih_home}\\mysql\\data\\"
	
	file { $pih_mysql_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_mysql_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_mysql/mysql-5.6.16-win32-min.zip",		
		require => File[$pih_mysql_home],
	}
	
	windows::unzip { $pih_mysql_zip:
		destination => $pih_mysql_home,
		creates	=> "${pih_mysql_home}\\bin",
		require => File[$pih_mysql_home],
	} ->
	
	file { $pih_mysql_ini: 
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_mysql/my.ini.erb'),	
	} ->
	
	exec { 'remove_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqld --remove",
		logoutput	=> true,
	} -> 
	
	exec { 'install_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqld --install",
		logoutput	=> true,
	} -> 
	
	exec { 'start_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c sc start mysql",
		logoutput	=> true,
	}
	
}