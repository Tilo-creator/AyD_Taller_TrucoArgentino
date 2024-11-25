# Usa una imagen base de Ruby
FROM ruby:3.3.5

# Configura el directorio de trabajo
WORKDIR /app

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Copia los archivos Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instala las gemas
RUN bundle install

# Copia el resto de la aplicación al contenedor

COPY config/ config/
COPY db/ db/
COPY Gemfile Gemfile.lock ./


# Expone el puerto de la aplicación
EXPOSE 3000

# Comando para iniciar el servidor
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
