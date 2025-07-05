# Dockerfile
FROM perl:5.38

# Install required Perl modules
RUN cpanm Plack Plack::App::CGIBin Plack::App::File

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Ensure CGI scripts are executable
RUN chmod -R +x public_html/cgi-bin

# Expose port for Railway (default 3000)
EXPOSE 3000

# Run the PSGI app with plackup
CMD ["plackup", "server.pl", "-p", "3000", "-E", "deployment"]
