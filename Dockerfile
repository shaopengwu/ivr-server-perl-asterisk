FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Asterisk, Apache, and Perl dependencies
RUN apt-get update && apt-get install -y \
    asterisk \
    curl \
    wget \
    vim \
    perl \
    libasterisk-agi-perl \
    apache2 \
    libcgi-pm-perl \
    dos2unix \
    && apt-get clean

# 1. Enable CGI modules
RUN a2enmod cgi && a2enconf serve-cgi-bin

# 2. Fix Apache Directory Permissions for CGI
RUN echo '<Directory "/usr/lib/cgi-bin">\n\
    AllowOverride None\n\
    Options +ExecCGI\n\
    AddHandler cgi-script .pl\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/cgi-fix.conf \
    && a2enconf cgi-fix

# 3. Prepare directories
WORKDIR /var/lib/asterisk/agi-bin
WORKDIR /usr/lib/cgi-bin

# Expose Web and VoIP ports
EXPOSE 80 5060/udp 5038 10000-10050/udp

# Startup script to fix permissions at runtime and start both services
CMD sh -c "chmod +x /usr/lib/cgi-bin/*.pl && chmod +x /var/lib/asterisk/agi-bin/*.pl && service apache2 start && asterisk -fvvvg"