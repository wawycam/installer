# WaWyCam dependencies installer

This repo will provide some files to quickly install and configure a WaWyCam based on Raspberry Pi 3 or Raspberry Zero W.

# Dependencies

To get all require dependencies simply copy and run the ```wawycam-install-dependencies.sh``` file on your raspberry pi.


```
# Create folder
mkdir /home/pi/wawy/installer
cd /home/pi/wawy/installer

# Get and extract installer file
wget https://github.com/wawycam/installer/wawycam-install-dependencies-1.0.0.tar.xz
tar -xvf wawycam-install-dependencies-1.0.0.tar.xz

# Execute installer
chmod u=rx wawycam-install-dependencies-1.0.0.sh
sudo ./wawycam-install-dependencies-1.0.0.sh
```

Now it's coffee time as on a Rapsberry PI 3, dependencies installation can take up to 10 minutes.

# Nginx Configuration

To allow your WaWyCam serve video stream and/or photo, you need to modify the Nginx config file.

```
# Create a copy of the config file
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.my

# Open the "default" config file
sudo vi /etc/nginx/sites-available/default
```

Replace all the default content by theses lines below.

```
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root /home/pi/wawycam;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}
	
	location /photos {
		alias /home/pi/wawycam/api/snap;
	}

	location /live {

		alias /run/shm/hls;

		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
		types {
			application/vnd.apple.mpegurl m3u8;
		}
	}



	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	#location ~ \.php$ {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php5-cgi alone:
	#	fastcgi_pass 127.0.0.1:9000;
	#	# With php5-fpm:
	#	fastcgi_pass unix:/var/run/php5-fpm.sock;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#	listen 80;
#	listen [::]:80;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}

```

Restart nginx

```
sudo service nginx restart
```