# Using Puppet, install flask from pip3

file { '/tmp/school':
  ensure  => 'file',
  group   => 'www-data',
  owner   => 'www-data',
  mode    => '0744',
  content => 'I love Puppet',
}
