# frozen_string_literal: true

# ApplicationRecord sirve como clase base abstracta para todos los modelos de la aplicación.
# Define configuraciones y métodos compartidos entre modelos y evita la duplicación de código.
# No representa una tabla en la base de datos.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
