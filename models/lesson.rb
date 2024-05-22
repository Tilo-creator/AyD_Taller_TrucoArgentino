require_relative 'application_record'
class Lesson < ApplicationRecord
    belongs_to :user
    has_many :Question, dependent: :destroy
  end
  