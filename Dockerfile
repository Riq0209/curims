FROM perl:5.34

ENV DEBIAN_FRONTEND=noninteractive

# Install Perl, Apache, CGI, and MySQL drivers
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        cpanminus \
        libdbd-mysql-perl \
        apache2 \
        apache2-utils \
        make gcc build-essential && \
    cpanm DBI CGI JSON LWP::Simple && \
    a2enmod cgi && \
    rm -rf /var/lib/apt/lists/*

# Set up Apache web root
RUN mkdir -p /var/www/html

# ✅ Copy your web files (including index.cgi at correct path)
COPY public_html/ /var/www/html/

# ✅ Copy Perl modules used by Webman framework
COPY webman/pm/ /usr/local/lib/webman/

# ✅ Make sure CGI scripts are executable
RUN chmod +x /var/www/html/cgi-bin/webman/curims/*.cgi

# ✅ Set custom Perl module search path (including core, comp, apps/curims)
ENV PERL5LIB=/usr/local/lib/webman:/usr/local/lib/webman/core:/usr/local/lib/webman/comp:/usr/local/lib/webman/apps/curims

# ✅ Copy Apache site config and startup script
COPY docker/apache-curims.conf /etc/apache2/sites-available/apache-curims.conf
COPY docker/start.sh /usr/local/bin/start.sh

# ✅ Make startup script executable
RUN chmod +x /usr/local/bin/start.sh

# ✅ Enable required modules and your site config
RUN a2enmod cgi rewrite && \
    a2ensite apache-curims.conf && \
    a2dissite 000-default.conf

# ✅ Start Apache in foreground
CMD ["/usr/local/bin/start.sh"]
