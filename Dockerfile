# Gunakan image PHP dengan Apache
FROM php:8.0-apache

# Aktifkan ekstensi PHP yang dibutuhkan (contoh: mysqli)
RUN docker-php-ext-install mysqli pdo pdo_mysql
    
# Salin seluruh source code ke dalam container
COPY . /var/www/html/

# Berikan izin yang sesuai untuk folder writable (dibutuhkan oleh CodeIgniter)
RUN chown -R www-data:www-data /var/www/html/writable && chmod -R 775 /var/www/html/writable
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
RUN echo 'DocumentRoot /var/www/html/public' >> /etc/apache2/sites-available/000-default.conf

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