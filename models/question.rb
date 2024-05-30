# models/question.rb
class Question < ApplicationRecord
    # Método para verificar si la respuesta proporcionada es correcta
    def correct_answer?(answer)
      self.correct_answer.downcase == answer.downcase
    end
  end
  