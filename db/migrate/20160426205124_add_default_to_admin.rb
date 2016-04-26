class AddDefaultToAdmin < ActiveRecord::Migration
  def change
    change_column :associations, :admin, :boolean, default: false
  end
end
