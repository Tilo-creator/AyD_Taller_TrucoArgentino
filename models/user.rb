class User < ActiveRecord::Base
  validates :names, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :lessons, dependent: :destroy
  has_many :statistics
  has_one :level

  def answer_question(correct)
    self.questions_answered ||= 0
    self.questions_correct ||= 0
    self.questions_incorrect ||= 0

    self.questions_answered += 1
    if correct
      self.questions_correct += 1
    else
      self.questions_incorrect += 1
    end
    save
  end
end
