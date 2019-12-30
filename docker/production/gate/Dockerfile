FROM steveltn/https-portal:1

COPY ./public /var/www/static_files
COPY ./nginx/http_config.erb /var/lib/nginx-conf/beta.shinchoku.net.conf.erb
COPY ./nginx/https_config.erb /var/lib/nginx-conf/beta.shinchoku.net.ssl.conf.erb