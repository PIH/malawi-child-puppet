class openmrs (

    $mysql_root_password = hiera('mysql_root_password'),
    $openmrs_db = hiera('openmrs_db'),
    $openmrs_db_user = hiera('openmrs_db_user'),
    $openmrs_db_password = hiera('openmrs_db_password'),
    $openmrs_auto_update_database = hiera('openmrs_auto_update_database'),    
    $tomcat = hiera('tomcat'), 
    $ssh_parent_address = hiera('ssh_parent_address'),
    $ssh_user = hiera('ssh_user'),
    $ssh_port = hiera('ssh_port'),
    $openmrs_db_remote = hiera('openmrs_db_remote'),
    $mysql_root_user = hiera('mysql_root_user'),
    $parent_mysql_root_user = hiera('parent_mysql_root_user'),
    $parent_mysql_db_password = hiera('parent_mysql_db_password'),
    $sync_admin_email = hiera('sync_admin_email'),
    $sync_parent_uuid = hiera('sync_parent_uuid'),
    $sync_parent_user_name = hiera('sync_parent_user_name'),
    $sync_parent_user_password = hiera('sync_parent_user_password') ,
    $sync_parent_name = hiera('sync_parent_name'),
    $sync_parent_address = hiera('sync_parent_address'),
    $child_name = hiera('child_name'),
    $openmrs_user = hiera('openmrs_user')

  ){

  require pih_java
  require pih_mysql
  require pih_tomcat

  $tomcat_home = $pih_tomcat::tomcat_home
  $tomcat_base = $pih_tomcat::tomcat_base
  $tomcat_user_home_dir = $pih_tomcat::tomcat_user_home_dir

  $openmrs_folder = "${tomcat_home}/.OpenMRS"
  $openmrs_db_folder = "${openmrs_folder}/db"  
  $runtime_properties_file = "${openmrs_folder}/openmrs-runtime.properties"
  $openmrs_db_tar = "openmrs.tar.gz"
  $dest_openmrs_db = "${openmrs_db_folder}/openmrs.tar.gz"
  $ssh_key = "${openmrs_db_folder}/id_rsa"
  $mysql_exe = "/usr/bin/mysql"
  $openmrs_dump_sql = "${openmrs_db_folder}/openmrs.sql"
  $modules_tar = "modules.tar.gz" 
  $dest_modules_tar = "${openmrs_folder}/${modules_tar}"
  $dest_openmrs_war = "${tomcat_base}/webapps/openmrs.war"
  $dest_modules = "${openmrs_folder}/modules"
  $openmrs_bin_folder = "${openmrs_folder}/bin"
  $server_uuid_text_file = "${openmrs_bin_folder}/${child_name}-serveruuid.txt"
  $output_server_uuid = regsubst($server_uuid_text_file, '[\\]', '/', G)
  $uploaded_child_server_uuid = "/tmp/${child_name}-serveruuid.txt"
  $check_For_Unsynced_Records_sh = "${openmrs_bin_folder}/checkForUnsyncedRecords.sql"
  $openmrs_create_db_sql = "${openmrs_bin_folder}/dropAndCreateDb.sql"
  $delete_sync_tables_sql = "${openmrs_bin_folder}/deleteSyncTables.sql"
  $update_child_server_settings_sql = "${openmrs_bin_folder}/updateChildServerSettings.sql"
  $update_parent_server_settings_sql = "${openmrs_bin_folder}/updateParentServerSettings.sql"  
  $initialize_openmrs_sh = "${openmrs_bin_folder}/initializeOpenMRS.sh"
  $remove_unsynced_changes_sh = "${openmrs_bin_folder}/remove_unsynced_changes.sh"
  $register_child_with_parent_sh = "${openmrs_bin_folder}/registerChildWithParent.sh"
  $remove_changeloglock_sh = "${openmrs_bin_folder}/remove_changeloglock.sh"
  $prepare_child_server_sh = "${openmrs_bin_folder}/prepareChildServer.sh"
  $openmrs_manager_sh = "${openmrs_bin_folder}/openmrsManager.sh"

  $icon_openmrs_manager = "/usr/share/applications/openmrsManager.desktop"
  $icon_openmrs_manager_desktop = "/home/openmrs/Desktop/openmrsManager.desktop"

  notify{"tomcat_base= ${tomcat_base}": }
  notify{"tomcat= ${tomcat}": }

  file { $openmrs_folder:
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',
    require => User[$tomcat]
  } ->

  file { "${tomcat_user_home_dir}/.OpenMRS":
    ensure => link,
    target => "${openmrs_folder}",  
  } ->

  file { $openmrs_db_folder:
    ensure  => directory,    
  } ->

  file { $openmrs_bin_folder:
    ensure  => directory,    
    mode  => '0777', 
  } ->

  file { $check_For_Unsynced_Records_sh: 
    ensure  => present, 
    content => template('openmrs/checkForUnsyncedRecords.sh.erb'),   
    mode    => '0755',
  } ->

  file { $openmrs_create_db_sql: 
    ensure  => present,  
    content => template('openmrs/dropAndCreateDb.sql.erb'), 
    mode    => '0755',
  } ->

  file { $prepare_child_server_sh: 
    ensure  => present,  
    content => template('openmrs/prepareChildServer.sh.erb'), 
    mode    => '0755',
  } ->

  file { $delete_sync_tables_sql: 
    ensure  => present,    
    source  => "puppet:///modules/openmrs/deleteSyncTables.sql",
    mode    => '0755',
  } ->   

  file { $initialize_openmrs_sh: 
    ensure  => present,  
    content => template('openmrs/initializeOpenMRS.sh.erb'), 
    mode    => '0755',
  } ->

  file { $remove_unsynced_changes_sh: 
    ensure  => present, 
    content => template('openmrs/remove_unsynced_changes.sh.erb'),   
    mode    => '0755',
  } ->

  file { $remove_changeloglock_sh: 
    ensure  => present, 
    content => template('openmrs/remove_changeloglock.sh.erb'),  
    mode    => '0755',
  } ->

  file { $update_child_server_settings_sql: 
    ensure  => present, 
    content => template('openmrs/updateChildServerSettings.sql.erb'), 
    mode    => '0755',
  } ->

  file { $update_parent_server_settings_sql: 
    ensure  => present, 
    content => template('openmrs/updateParentServerSettings.sql.erb'), 
    mode    => '0755',
  } ->

  file { $register_child_with_parent_sh: 
    ensure  => present, 
    content => template('openmrs/registerChildWithParent.sh.erb'), 
    mode    => '0755',
  } ->

  file { $icon_openmrs_manager: 
    ensure  => present, 
    content => template('openmrs/openmrsManager.desktop.erb'), 
    mode    => '0755',
  } ->

  file { $icon_openmrs_manager_desktop: 
    ensure  => present, 
    content => template('openmrs/openmrsManager.desktop.erb'), 
    mode    => '0777',
  } ->

  file { $openmrs_manager_sh: 
    ensure  => present, 
    content => template('openmrs/openmrsManager.sh.erb'), 
    mode    => '0755',
  } ->

  file { $ssh_key: 
    ensure  => present, 
    source  => "puppet:///modules/openmrs/id_rsa",
    mode    => '0600',
  } ->

  file { $dest_openmrs_db:
    ensure  => file,    
    source  => "puppet:///modules/openmrs/${openmrs_db_tar}",        
  } -> 

  exec { 'openmrs-db-unzip':
    cwd     => $openmrs_db_folder,
    command => "tar -xzf ${dest_openmrs_db}",    
  } -> 

  file { $dest_modules_tar:
    ensure  => file,
    owner   => $tomcat,
    group   => $tomcat,
    source  => "puppet:///modules/openmrs/${modules_tar}",    
    mode    => '0755',
  } -> 
  
  exec { 'delete-modules':
    cwd     => $openmrs_folder,
    command => "rm -rf ${openmrs_folder}/modules",
    onlyif  => "test -d ${openmrs_folder}/modules",   
  } ->

  exec { 'modules-unzip':
    cwd     => $openmrs_folder,
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_modules_tar}",    
  } ->

  file { "${openmrs_folder}/modules":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => inf,
  } ->

  file { $dest_openmrs_war:
    ensure  => file,
    source  => "puppet:///modules/openmrs/openmrs.war",    
    mode    => '0755',
    owner   => $tomcat,
    group   => $tomcat,
  } -> 

  file { $runtime_properties_file:
    ensure  => present,
    content => template('openmrs/openmrs-runtime.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',    
  } ->

  exec { 'initialize openmrs db folder':
    cwd     => $openmrs_bin_folder,
    command => "${initialize_openmrs_sh}",    
    logoutput => true, 
    timeout => 0, 
  } 

}
