# Stage 1: Build & Packaging
FROM php:8.3-cli-alpine AS final

# Security: Set working directory and create a dedicated non-root user
WORKDIR /var/www/html
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy application source code with non-root ownership
COPY --chown=appuser:appgroup src/ /var/www/html/

# Security: Switch from root to non-root execution context
USER appuser

# Expose internal listening port
EXPOSE 8080

# Configure health check for container engine
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD php -r '$res = @file_get_contents("http://127.0.0.1:8080/"); exit($res !== false ? 0 : 1);'

# Start built-in PHP web server bound to all container interfaces
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]