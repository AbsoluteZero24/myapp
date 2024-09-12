# Gunakan image PHP dengan Apache
FROM php:8.0-apache

# Aktifkan ekstensi PHP yang dibutuhkan (contoh: mysqli)
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>\n' > /etc/apache2/conf-available/codeigniter.conf \
    && a2enconf codeigniter \
    && service apache2 reload
    
# Salin seluruh source code ke dalam container
COPY . /var/www/html/

# Berikan izin yang sesuai untuk folder writable (dibutuhkan oleh CodeIgniter)
RUN chown -R www-data:www-data /var/www/html/writable && chmod -R 775 /var/www/html/writable

# Expose port 80 untuk Apache
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]