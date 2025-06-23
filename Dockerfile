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

# ✅ Copy your CGI + HTML frontend (as-is)
COPY public_html/cgi-bin/ /var/www/cgi-bin/

# ✅ Copy your backend Perl modules
COPY webman/pm/ /usr/local/lib/webman/

# ✅ Make CGI scripts executable
RUN find /var/www/cgi-bin/ -name "*.cgi" -exec chmod +x {} \;

# ✅ Apache config to enable CGI
RUN echo "ScriptAlias /cgi-bin/ /var/www/cgi-bin/" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "<Directory /var/www/cgi-bin>" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    Options +ExecCGI" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "    AddHandler cgi-script .cgi" >> /etc/apache2/sites-enabled/000-default.conf && \
    echo "</Directory>" >> /etc/apache2/sites-enabled/000-default.conf

# ✅ Add your custom lib path for Perl to find .pm modules
ENV PERL5LIB=/usr/local/lib/webman

EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
