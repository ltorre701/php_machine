# Use the official Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install prerequisites
RUN apt-get update && \
    apt-get install -y software-properties-common curl gnupg2 git vim tmux

# Add the PHP repository and install PHP 8.1
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
        php8.1 \
        php8.1-cli \
        php8.1-fpm \
        php8.1-mysql \
        php8.1-xml \
        php8.1-curl

# Install Apache2 and the PHP module for Apache
RUN apt-get install -y apache2 libapache2-mod-php8.1

# Enable Apache modules
RUN a2enmod rewrite

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

# Set ownership to the default user
RUN chown codespace:codespace /home/codespace/.vimrc /home/codespace/.tmux.conf

# Symlink the workspace to Apache's document root
RUN ln -s /workspace /var/www/html

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

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose Apache's port
EXPOSE 80

# Start Apache and keep the container running
CMD ["bash", "-c", "service apache2 start && tail -f /dev/null"]
