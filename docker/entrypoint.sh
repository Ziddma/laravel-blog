#!/bin/bash

# Install dependencies if not already installed
if [ ! -f "vendor/autoload.php" ]; then
    echo "Installing composer dependencies..."
    composer install --no-progress --no-interaction
fi

if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example"
    cp .env.example .env
fi

# Run Laravel commands
echo "Running Laravel setup..."
php artisan migrate --force
php artisan key:generate
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan storage:link

# Serve the application
echo "Starting Laravel application on port $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT

exec docker-php-entrypoint "$@"
