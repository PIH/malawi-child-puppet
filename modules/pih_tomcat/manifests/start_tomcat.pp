define pih_tomcat::start_tomcat {
  
	exec { 'start_tomcat': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c set JAVA_HOME=${pih_java_home}&&sc start Tomcat6",
		logoutput	=> true,
	}
	
}