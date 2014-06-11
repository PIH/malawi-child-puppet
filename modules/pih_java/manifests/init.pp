class pih_java {

	file { 'c:\dev\openmrs\test\test.zip':
		ensure  => file,
		source	=> "puppet:///modules/pih_java/test.zip",				
	}
	
	file { 'c:\dev\openmrs\test\testunzip':
		ensure  => directory,
		require => File['c:\dev\openmrs\test\test.zip'],
	}

	windows::unzip { 'C:\dev\openmrs\test\test.zip':
		destination => 'C:\dev\openmrs\test\testunzip',
		creates	=> 'C:\dev\openmrs\test\testunzip\islandView_page17.jpg',
		require => File['c:\dev\openmrs\test\testunzip'],
	}
}