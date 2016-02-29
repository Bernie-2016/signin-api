class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :event
      t.string :title
      t.string :type

      t.timestamps null: false
    end
  end
end
