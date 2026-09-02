FROM php:8.4-fpm

# Install system dependencies & PHP extension helpers
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# # Install PHP extensions required by Laravel & MariaDB
# RUN docker-php-ext-install pdo_mysql mbstring exac pdo bcmath gd

# # Configure GD extension
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions required by Laravel & MariaDB
RUN docker-php-ext-install pdo_mysql mbstring bcmath gd


# Set working directory
WORKDIR /var/www

# Copy existing application
COPY . /var/www

# Assign permissions to Laravel storage & cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]