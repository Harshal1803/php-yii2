# Start from PHP 8.2 with Apache (Buster)
FROM php:8.2-apache-buster

# Update the package list and install security updates
RUN apt-get update && apt-get upgrade -y

# Install required dependencies
RUN apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    libpq-dev \
    libxslt-dev \
    zlib1g-dev \
    libonig-dev \
    libwebp-dev

# Configure and install GD first (needs special handling)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install gd

# Install other PHP extensions
RUN docker-php-ext-install \
    mbstring \
    pdo_mysql \
    exif \
    bcmath \
    opcache \
    xml \
    xsl \
    zip \
    pdo \
    curl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/yii2-docker-app

# Copy the app code
COPY . /var/www/yii2-docker-app

# Set permissions
RUN chown -R www-data:www-data /var/www/yii2-docker-app && \
    chmod -R 755 /var/www/yii2-docker-app

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]