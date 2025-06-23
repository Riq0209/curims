# Use official Perl image with Apache
FROM perl:5.38-apache-bookworm

# Install system dependencies and required Perl modules
RUN apt-get update && apt-get install -y \
    libcgi-pm-perl \
    libdbi-perl \
    libdbd-mysql-perl \
    libnet-ftp-perl \
    libfile-listing-perl \
    libnet-domain-perl \
    libcgi-session-perl \
    && rm -rf /var/lib/apt/lists/*

# Install additional CPAN modules if needed
RUN cpanm CGI::Session \
    DBI \
    DBD::mysql \
    Net::FTP \
    File::Listing \
    Net::Domain

# Configure Apache for CGI
RUN a2enmod cgi \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set up the document root
ENV APACHE_DOCUMENT_ROOT /var/www/html
ENV APACHE_CGI_BIN /usr/lib/cgi-bin

# Create necessary directories and set permissions
RUN mkdir -p ${APACHE_DOCUMENT_ROOT} \
    && mkdir -p ${APACHE_CGI_BIN} \
    && chown -R www-data:www-data ${APACHE_DOCUMENT_ROOT} \
    && chmod -R 755 /usr/lib/cgi-bin

# Copy application files
COPY public_html/ ${APACHE_DOCUMENT_ROOT}/
COPY webman/ /var/www/webman/

# Set up CGI scripts
RUN find ${APACHE_DOCUMENT_ROOT}/cgi-bin/ -type f -name '*.cgi' -exec chmod +x {} \;

# Configure Apache to allow .htaccess overrides and enable CGI execution
RUN echo "<Directory ${APACHE_DOCUMENT_ROOT}>\n    Options Indexes FollowSymLinks\n    AllowOverride All\n    Require all granted\n</Directory>" > /etc/apache2/conf-available/custom.conf \
    && echo "<Directory ${APACHE_DOCUMENT_ROOT}/cgi-bin>\n    Options +ExecCGI\n    AddHandler cgi-script .cgi\n    Require all granted\n</Directory>" >> /etc/apache2/conf-available/custom.conf \
    && echo "ScriptAlias /cgi-bin/ ${APACHE_DOCUMENT_ROOT}/cgi-bin/" >> /etc/apache2/conf-available/custom.conf \
    && a2enconf custom

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
