#!/bin/bash

# Railway provides a PORT environment variable. Default to 8080 if it's not set.
PORT="${PORT:-8080}"

# Update Apache configuration to listen on the correct port.
sed -i "s/LISTEN_PORT/$PORT/g" /etc/apache2/sites-available/apache-curims.conf
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf

# Start Apache in the foreground
exec /usr/sbin/apache2ctl -D FOREGROUND
