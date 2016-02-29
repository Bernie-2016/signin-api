class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.string :name
      t.string :slug
      t.date :date
      t.text :fields

      t.timestamps null: false
    end
  end
end
