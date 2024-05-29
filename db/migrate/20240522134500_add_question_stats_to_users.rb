# db/migrate/xxxxxx_add_options_to_questions.rb
class AddOptionsToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :options, :text
  end
end
