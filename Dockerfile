FROM perl:5.34

ENV DEBIAN_FRONTEND=noninteractive

# Install Perl, Apache, CGI support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdbi-perl \
        libdbd-mysql-perl \
        libcgi-pm-perl \
        apache2 \
        apache2-utils && \
    a2enmod cgi && \
    rm -rf /var/lib/apt/lists/*

# Create required web folders
RUN mkdir -p /var/www/html /var/www/cgi-bin

# Copy your web files
COPY public_html/ /var/www/html/

# Copy your backend Perl modules
COPY webman/pm/ /usr/local/lib/webman/

# Make CGI scripts executable
RUN find /var/www/html/cgi-bin/ -name "*.cgi" -exec chmod +x {} \;

# Add your custom lib path for Perl to find .pm modules
ENV PERL5LIB=/usr/local/lib/webman

# Copy custom Apache config and startup script
COPY docker/apache-curims.conf /etc/apache2/sites-available/apache-curims.conf
COPY docker/start.sh /usr/local/bin/start.sh

# Make startup script executable
RUN chmod +x /usr/local/bin/start.sh

# Enable cgi module, our site, and disable the default
RUN a2enmod cgi && \
    a2ensite apache-curims.conf && \
    a2dissite 000-default.conf

# Railway provides the PORT env var, so no need to EXPOSE

CMD ["/usr/local/bin/start.sh"]
