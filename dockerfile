FROM matomo:latest

# Create a group and user
RUN groupadd -g 1001 matomo && \
    useradd -r -u 1001 -g matomo matomo


COPY app/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf

# Change the ownership of the Matomo directory and Apache log directory to our new user and group
RUN chown -R matomo:matomo /var/www/html && \
    chown -R matomo:matomo /var/log/apache2

# Change the permissions of the Matomo directory and Apache log directory
RUN chmod -R 755 /var/www/html
RUN chmod -R 755 /var/log/apache2


# Change Apache to listen on port 8080
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf

# Set the ServerName directive to suppress the AH00558 warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Change to non-root privilege
USER matomo

EXPOSE 8080
