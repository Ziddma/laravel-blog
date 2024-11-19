#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    echo "Installing composer dependencies..."
    composer install --no-progress --no-interaction --ignore-platform-reqs
fi

if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
fi

echo "Building Vite assets..."
npm run build

if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example"
    cp .env.example .env
fi


echo "Running Laravel setup..."
php artisan migrate --force
php artisan key:generate
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan storage:link


if [ "$APP_ENV" == "local" ]; then
    echo "Running migrations and seeding database..."
    php artisan migrate:fresh --seed || exit 1
fi


if [ "$APP_ENV" == "local" ]; then
    echo "Compiling assets using Node..."
    yarn install && yarn dev
fi


echo "Starting Laravel application on port $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT

exec docker-php-entrypoint "$@"
