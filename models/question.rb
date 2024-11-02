# frozen_string_literal: true

# Dependencias
# models/question.rb
class Question < ApplicationRecord
  # Método para verificar si la respuesta proporcionada es correcta
  def correct_answer?(answer)
    correct_answer.downcase == answer.downcase
  end
end
