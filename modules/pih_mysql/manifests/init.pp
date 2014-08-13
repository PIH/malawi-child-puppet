class pih_mysql {
    
	require pih_java
	
	if $architecture == 'x64' { 
		$mysql_zip = 'mysql-5.6.16-winx64-min.zip'
	} else {
		$mysql_zip = 'mysql-5.6.16-win32-min.zip'
	}
	
	$pih_mysql_zip = "${pih_home_bin}\\${mysql_zip}"
	
	$pih_mysql_ini = "${pih_home}\\mysql\\my.ini"
	$pih_mysql_data = "${pih_home}\\mysql\\data\\"
	
	file { $pih_mysql_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_mysql_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_mysql/${mysql_zip}",		
		require => File[$pih_mysql_home],
	} ->
	
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
	
	windows::path { "${pih_mysql_home}\\bin": } -> 
	
	exec { 'stop_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c net stop mysql",
		onlyif		=> "cmd.exe /c sc query mysql",
		unless		=> "cmd.exe /c sc query mysql | find \"STOPPED\"",
		logoutput	=> true, 
		returns		=> [0, 1, 2],
	} -> 
	
	exec { 'remove_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqld --remove",
		onlyif		=> "cmd.exe /c sc query mysql",
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