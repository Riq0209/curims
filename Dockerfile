FROM perl:5.34

# Install required system packages for DBD::mysql to compile
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdbi-perl \
        libdbd-mysql-perl \
        libcgi-pm-perl \
        apache2 && \
    a2enmod cgi

# Create required directories
RUN mkdir -p /var/www/html /var/www/cgi-bin

# Copy frontend (optional)
COPY public_html/ /var/www/html/

# Copy nested CGI scripts (preserve your structure)
COPY public_html/cgi-bin/ /var/www/cgi-bin/

# Make all .cgi scripts executable, even in subfolders
RUN find /var/www/cgi-bin/ -name "*.cgi" -exec chmod +x {} \;

# Configure Apache for CGI execution in all subdirectories
RUN echo "ScriptAlias /cgi-bin/ /var/www/cgi-bin/" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "<Directory /var/www/cgi-bin>" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    Options +ExecCGI" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    AddHandler cgi-script .cgi" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "</Directory>" >> /etc/apache2/sites-enabled/000-default.conf

# Expose Railway-compatible port
EXPOSE 8080

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
