WSGIDaemonProcess www-data
WSGIProcessGroup www-data

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /root/vatic/public

    <Directory /root/vatic/public>
        Options Indexes FollowSymLinks MultiViews Includes ExecCGI
        AllowOverride all
        Order allow,deny
        allow from all
        Satisfy Any
    </Directory>

    <Directory />
        Options Indexes FollowSymLinks Includes
        AllowOverride None
    </Directory>

    <Directory /var/www/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride None
        Order allow,deny
        allow from all
        Require all granted
    </Directory>

    ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/

    <Directory "/usr/lib/cgi-bin">
        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log

    LogLevel warn

    CustomLog ${APACHE_LOG_DIR}/access.log combined
    WSGIScriptAlias /server /root/vatic/server.py

Alias /doc/ "/usr/share/doc/"

    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Allow from 127.0.0.0/255.0.0.0 ::1/128
        Require all granted
    </Directory>

</VirtualHost>
