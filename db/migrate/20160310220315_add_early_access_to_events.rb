class AddEarlyAccessToEvents < ActiveRecord::Migration
  def change
    add_column :events, :early_access, :boolean, default: false
  end
end
