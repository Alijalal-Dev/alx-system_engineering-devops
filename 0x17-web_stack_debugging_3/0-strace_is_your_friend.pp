# Ensure Apache is installed

package { 'apache2':
  ensure => installed,
}

# Ensure the Apache service is running and enabled
service { 'apache2':
  ensure    => running,
  enable    => true,
  require   => Package['apache2'],
}

# Fix the 500 error by correcting the .phpp typo in wp-settings.php
exec { 'fix_phpp_typo':
  command => 'sed -i "s/.phpp/.php/" /var/www/html/wp-settings.php',
  onlyif  => 'grep -q ".phpp" /var/www/html/wp-settings.php',
  path    => ['/bin', '/usr/bin'],
  require => Package['apache2'],
  notify  => Service['apache2'],
}

# Ensure the wp-settings.php file exists and has correct permissions
file { '/var/www/html/wp-settings.php':
  ensure  => file,
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0644',
  require => Package['apache2'],
}
