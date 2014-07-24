class gzip {
    
	$gzip_zip = 'gzip-1.3.12-1-bin.zip'
	
	$pih_gzip_zip = "${pih_home_bin}\\${gzip_zip}"
	
	file { $pih_gzip_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_gzip_zip:
		ensure  => file,
		source	=> "puppet:///modules/gzip/${gzip_zip}",		
		require => File[$pih_gzip_home],
	}
	
	windows::unzip { $pih_gzip_zip:
		destination => $pih_gzip_home,
		creates	=> "${pih_gzip_home}\\bin\\gzip.exe",
		require => File[$pih_gzip_zip],
	} ->
	
	windows::path { "${pih_gzip_home}\\bin": } 

}