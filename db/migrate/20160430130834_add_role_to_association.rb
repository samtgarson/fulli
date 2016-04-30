class AddRoleToAssociation < ActiveRecord::Migration
  def change
    rename_column :associations, :admin, :role
    change_column :associations, :role, :string
  end
end
