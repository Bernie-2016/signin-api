class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.belongs_to :event
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :email
      t.string :zip
      t.string :can_text
      t.text :extra_fields
      t.boolean :posted_bsd, default: false

      t.timestamps null: false
    end
  end
end
