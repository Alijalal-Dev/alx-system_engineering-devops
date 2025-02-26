# fixing apache 500 error

exec { 'Fixing 500 error':
  command  => 'sudo sed -i "s/.phpp/.php/" /var/www/html/wp-settings.php',
  provider => shell,
}
