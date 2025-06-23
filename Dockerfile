FROM perl:5.34

ENV DEBIAN_FRONTEND=noninteractive

# Install Perl modules and Apache with CGI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdbi-perl \
        libdbd-mysql-perl \
        libcgi-pm-perl \
        apache2 \
        apache2-utils && \
    a2enmod cgi && \
    rm -rf /var/lib/apt/lists/*

# Create base folders
RUN mkdir -p /var/www/html /var/www/cgi-bin

# Optional: copy frontend
COPY public_html/ /var/www/html/

# ✅ Copy your actual CGI files (preserve nested structure)
COPY webman/pm/ /var/www/cgi-bin/

# ✅ Make all .cgi scripts executable
RUN find /var/www/cgi-bin/ -name "*.cgi" -exec chmod +x {} \;

# ✅ Apache CGI config
RUN echo "ScriptAlias /cgi-bin/ /var/www/cgi-bin/" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "<Directory /var/www/cgi-bin>" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    Options +ExecCGI" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    AddHandler cgi-script .cgi" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "</Directory>" >> /etc/apache2/sites-enabled/000-default.conf

# Expose port
EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
