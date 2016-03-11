class AddChoicesToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :choices, :text
  end
end
