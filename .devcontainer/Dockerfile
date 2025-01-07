# Use the pre-built PHP dev container image as the base
FROM mcr.microsoft.com/devcontainers/php:1-8.3

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install prerequisites
RUN apt-get update && \
    apt-get install -y \
        mysql-server \
        phpmyadmin \
        supervisor \
        vim \
        tmux \
        git \
        curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure MySQL
RUN service mysql start && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';" && \
    mysql -e "CREATE DATABASE IF NOT EXISTS your_database;" && \
    mysql -e "CREATE USER 'your_user'@'localhost' IDENTIFIED BY 'your_password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON your_database.* TO 'your_user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Configure phpMyAdmin
RUN echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf && \
    sed -i 's/AllowNoPassword false/AllowNoPassword true/' /etc/phpmyadmin/config.inc.php

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

# Expose Apache's and MySQL's ports
EXPOSE 80 3306

# Start supervisor which manages Apache and MySQL
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
