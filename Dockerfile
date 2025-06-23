FROM perl:5.34

# Install required system packages for DBD::mysql to compile
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdbi-perl \
        libdbd-mysql-perl \
        libcgi-pm-perl

# Install Apache with CGI support
RUN apt-get update && apt-get install -y apache2 && \
    a2enmod cgi

# Create required directories
RUN mkdir -p /var/www/html /var/www/cgi-bin

# Copy frontend (HTML/CSS/JS)
COPY public_html/ /var/www/html/

# Copy backend Perl scripts
COPY webman/ /var/www/cgi-bin/

# Make scripts executable
RUN find /var/www/cgi-bin/ -name "*.cgi" -exec chmod +x {} \;

# Configure Apache for CGI
RUN echo "ScriptAlias /cgi-bin/ /var/www/cgi-bin/" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "<Directory /var/www/cgi-bin>" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    Options +ExecCGI" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    AddHandler cgi-script .cgi" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "</Directory>" >> /etc/apache2/sites-enabled/000-default.conf

# Expose port for Railway
EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]