define pih_tomcat::stop_tomcat {
  
	exec { 'stop_tomcat': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c set JAVA_HOME=${pih_java_home}&&sc stop Tomcat6",
		logoutput	=> true,
	}
	
}