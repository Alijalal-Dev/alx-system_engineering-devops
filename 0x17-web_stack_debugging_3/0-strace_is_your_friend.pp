# Fixing Apache 500 error by correcting the .phpp to .php in wp-settings.php
exec { 'fix-wordpress':
  command  => 'sed -i "s/.phpp/.php/" /var/www/html/wp-settings.php',
  path     => ['/bin', '/usr/bin'],
  onlyif   => 'grep -q ".phpp" /var/www/html/wp-settings.php',
  provider => shell,
}

# Restart Apache to apply changes
service { 'apache2':
  ensure    => running,
  enable    => true,
  subscribe => Exec['fix-wordpress'],
}
