# Use an official PHP image with Apache
FROM php:8.0-apache

# Install necessary extensions for MySQL and PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the local project files to the container
COPY . /var/www/html/online-banking

# Set permissions for the project directory
RUN chown -R www-data:www-data /var/www/html/online-banking

# Install PHPMyAdmin
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip && \
    unzip phpMyAdmin-latest-all-languages.zip -d /var/www/html && \
    mv /var/www/html/phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    rm phpMyAdmin-latest-all-languages.zip

# Set the environment variables for the database connection
ENV DB_HOST=127.0.0.1
ENV DB_NAME=bank_db
ENV DB_USER=root
ENV DB_PASSWORD=password

# Expose port 80 to make the application accessible
EXPOSE 80

# Start Apache service in the foreground
CMD ["apache2-foreground"]
