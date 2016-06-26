class FixFieldsForUserAndEmployee < ActiveRecord::Migration
  def change
    drop_table :employees
    drop_table :associations

    change_table :users do |t|
      t.datetime :date_joined
      t.string :title
      t.string :ancestry
      t.integer :ancestry_depth, default: 0
      t.string :role
      t.references :organisation, index: true, foreign_key: true, type: :uuid
    end

    rename_column :employee_skills, :employee_id, :user_id
  end
end
