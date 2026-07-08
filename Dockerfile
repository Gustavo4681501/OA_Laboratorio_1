FROM wordpress:latest

# Actualizar dependencias y instalar less(visor de texto para logs) y vim (editor de texto)
RUN apt-get update && apt-get install -y \
    less \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Copiar configuración personalizada de PHP 
WORKDIR /var/www/html

EXPOSE 80