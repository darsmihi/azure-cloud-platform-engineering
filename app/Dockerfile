# Stage 1 Build & Package
FROM php:8.3-cli-alpine AS final

#Security: Set Working Directory and create a non-root user
WORKDIR /var/www/html
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy application source code with no root permissions
COPY --chown=appuser:appgroup src /var/www/html/

#Security: Switch from root to non-root execution context
USER appuser

# Expose intenral listening port
EXPOSE 8080

# Configure health check for container engine
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD php -r 'exit(@file_get_contents("http://localhost:8080/health") === 'OK' ? 0 : 1);' || exit 1

# Start built-in PHP web server bound to all container interfaces
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]