# Start from Ubuntu 22.04 (or 20.04 if you prefer)
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
       vim \
       tmux \
       curl \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       apache2 \
       php8.1 \
       php8.1-cli \
       php8.1-common \
       php8.1-curl \
       php8.1-zip \
       php8.1-xml \
       php8.1-mbstring \
       libapache2-mod-php8.1

# Clean up apt caches
RUN rm -rf /var/lib/apt/lists/*

# Configure Apache to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80>/:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose port 8080 to the host
EXPOSE 8080

# By default, Apache runs on foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
