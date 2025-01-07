# Use the pre-built PHP dev container image as the base
FROM mcr.microsoft.com/devcontainers/php:1-8.3

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Enable contrib and non-free in sources.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian bookworm main/s/main/main contrib non-free/' /etc/apt/sources.list && \
    sed -i '/deb http:\/\/deb.debian.org\/debian-security bookworm-security main/s/main/main contrib non-free/' /etc/apt/sources.list

# Update package lists
RUN apt-get update

# Install required packages
RUN apt-get install -y \
    mariadb-server \
    supervisor \
    vim \
    tmux \
    git \
    curl \
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install phpMyAdmin manually
RUN mkdir -p /usr/share/phpmyadmin && \
    curl -Lo /tmp/phpmyadmin.zip https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip && \
    unzip /tmp/phpmyadmin.zip -d /usr/share/phpmyadmin && \
    rm /tmp/phpmyadmin.zip && \
    mv /usr/share/phpmyadmin/phpMyAdmin-*-all-languages/* /usr/share/phpmyadmin/ && \
    rmdir /usr/share/phpmyadmin/phpMyAdmin-*-all-languages

# Configure phpMyAdmin
RUN mkdir -p /var/www/html/phpmyadmin && \
    ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin && \
    cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php && \
    sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = 'a_random_blowfish_secret';/" /usr/share/phpmyadmin/config.inc.php

# Install Vim-Plug for plugin management
RUN curl -fLo /home/codespace/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    chown -R codespace:codespace /home/codespace/.vim

# Install Tmux Plugin Manager (TPM)
RUN git clone https://github.com/tmux-plugins/tpm.git /home/codespace/.tmux/plugins/tpm && \
    chown -R codespace:codespace /home/codespace/.tmux

# Set the working directory
WORKDIR /workspace

# Copy custom Vim and Tmux configurations
COPY .vimrc /home/codespace/.vimrc
COPY .tmux.conf /home/codespace/.tmux.conf

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set ownership to the default user
RUN chown codespace:codespace /home/codespace/.vimrc /home/codespace/.tmux.conf

# Symlink the workspace to Apache's document root
RUN rm -rf /var/www/html && ln -s /workspace /var/www/html

# Ensure the workspace and document root have the correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chown -R codespace:codespace /workspace

# Switch to the codespace user for plugin installations
USER codespace

# Install Vim plugins
RUN vim +PlugInstall +qall

# Install Tmux plugins
RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Switch back to root for the remaining setup
USER root

# Expose Apache's and MariaDB's ports
EXPOSE 80 3306

# Start supervisor which manages Apache and MariaDB
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
