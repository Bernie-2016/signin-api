class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :role, default: 0

      t.timestamps null: false
    end
  end
end
