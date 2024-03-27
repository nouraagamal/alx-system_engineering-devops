#Install Nginx web server (w/ Puppet)

exec { 'update system':
        command => '/usr/bin/apt-get update',
}

package { 'nginx':
	ensure => 'installed',
	require => Exec['update system']
}

file {'/var/www/html/index.html':
	content => 'Hello World!'
}

exec {'redirect_me':
	command => 'sed -i "24i\	rewrite ^/redirect_me https://github.com/nouraagamal/ permanent;" /etc/nginx/sites-available/default',
	provider => 'shell'
}

file {'/var/www/html/error_404.html':
	content => 'Ceci n'est pas une page'
}

exec {'error_404':
	command => 'sed -i "25i\	 error_page 404 /error_404.html;' /etc/nginx/sites-available/default',
	provider => 'shell'
}

service {'nginx':
	ensure => running,
	require => Package['nginx']
}
