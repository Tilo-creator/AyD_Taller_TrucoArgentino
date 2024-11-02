# frozen_string_literal: true

require_relative 'application_record'
# Dependencias
class Lesson < ApplicationRecord
  belongs_to :user
  has_many :Question, dependent: :destroy
end
