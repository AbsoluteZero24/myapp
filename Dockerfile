# Gunakan image PHP dengan Apache
FROM php:8.1-apache

# Aktifkan ekstensi PHP yang dibutuhkan (contoh: mysqli)
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN apt-get update && apt-get install -y vim
    
# Salin seluruh source code ke dalam container
COPY . /var/www/html/

# Pastikan direktori public adalah root untuk Apache
WORKDIR /var/www/html/public

# Berikan izin yang sesuai untuk folder writable (dibutuhkan oleh CodeIgniter)
RUN chown -R www-data:www-data /var/www/html/writable && chmod -R 775 /var/www/html/writable

# Enable mod_rewrite untuk CodeIgniter
RUN a2enmod rewrite

# Set ServerName untuk menghindari peringatan Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port 80 untuk Apache
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]

# Pastikan konfigurasi Apache mengizinkan akses ke direktori public
RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/codeigniter.conf \
    && a2enconf codeigniter
#RUN echo 'DocumentRoot /var/www/html/public' >> /etc/apache2/sites-available/000-default.conf