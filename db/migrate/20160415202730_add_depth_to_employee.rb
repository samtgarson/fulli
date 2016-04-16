class AddDepthToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :ancestry_depth, :integer, default: 0
  end
end
