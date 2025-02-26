# 0-strace_is_your_friend.pp

# Ensure the Apache service is running
service { 'apache2':
  ensure => running,
  enable => true,
}

# Fix the 500 error by correcting the .phpp typo in wp-settings.php
exec { 'fix_phpp_typo':
  command => 'sed -i "s/.phpp/.php/" /var/www/html/wp-settings.php',
  onlyif  => 'grep -q ".phpp" /var/www/html/wp-settings.php',
  path    => ['/bin', '/usr/bin'],
  notify  => Service['apache2'],
}

# Ensure the wp-settings.php file exists
file { '/var/www/html/wp-settings.php':
  ensure => file,
  owner  => 'www-data',
  group  => 'www-data',
  mode   => '0644',
}
