FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Asterisk, Apache, and Perl dependencies
RUN apt-get update && apt-get install -y \
    asterisk \
    curl \
    vim \
    perl \
    libasterisk-agi-perl \
    apache2 \
    cpanminus \
    # for oracle db lib installation supports
    libcgi-pm-perl libdbi-perl libaio1t64 build-essential  unzip \
    dos2unix \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



# 2. Install Oracle Instant Client (Basic & SDK)
# Note: You may need to update the version numbers/links to the latest 19.x or 21.x
WORKDIR /opt/oracle
# RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
#     wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip && \
#     unzip instantclient-basic-linux.x64-21.1.0.0.0.zip && \
#     unzip instantclient-sdk-linux.x64-21.1.0.0.0.zip && \
#     rm *.zip
# Using the ARM64 (aarch64) links for Oracle 19c (most stable for ARM64)
RUN wget https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-basic-linux.arm64-19.19.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-sdk-linux.arm64-19.19.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.arm64-19.19.0.0.0dbru.zip && \
    unzip instantclient-sdk-linux.arm64-19.19.0.0.0dbru.zip && \
    rm *.zip

# 3. Set Environment Variables (Crucial for Perl and Oracle)
ENV ORACLE_HOME=/opt/oracle/instantclient_19_19
ENV LD_LIBRARY_PATH=$ORACLE_HOME
ENV C_INCLUDE_PATH=$ORACLE_HOME/sdk/include
ENV LIBRARY_PATH=$ORACLE_HOME
ENV PATH=$PATH:$ORACLE_HOME

RUN echo "/opt/oracle/instantclient_19_19" > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig
# Tell Apache to pass Oracle environment variables to CGI scripts
RUN echo "PassEnv ORACLE_HOME" >> /etc/apache2/apache2.conf && \
    echo "PassEnv LD_LIBRARY_PATH" >> /etc/apache2/apache2.conf    
# 3. Create the symlinks required for the compiler
# 3. Create/Ensure the symlinks required for the compiler
RUN ln -sf $ORACLE_HOME/libclntsh.so.19.1 $ORACLE_HOME/libclntsh.so && \
    ln -sf $ORACLE_HOME/libclntshcore.so.19.1 $ORACLE_HOME/libclntshcore.so

# 4. Correct libaio symlink for ARM64 (Ubuntu 24.04)
RUN ln -sf /usr/lib/aarch64-linux-gnu/libaio.so.1t64 /usr/lib/aarch64-linux-gnu/libaio.so.1

# 3. Install DBD::Oracle with "plain" output to see errors if it fails
RUN cpanm --verbose --notest DBD::Oracle

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
# 1. Enable CGI modules
RUN a2enmod cgi && a2enconf serve-cgi-bin

# Expose Web and VoIP ports
EXPOSE 80 5060/udp 5038 10000-10050/udp

# Startup script to fix permissions at runtime and start both services
# CMD sh -c "chmod +x /usr/lib/cgi-bin/*.pl && chmod +x /var/lib/asterisk/agi-bin/*.pl && service apache2 start && asterisk -fvvvg"
# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Recommended JSON/Exec form
ENTRYPOINT ["/entrypoint.sh"]