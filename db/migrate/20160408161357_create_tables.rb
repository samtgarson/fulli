class CreateTables < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.timestamps null: false
    end

    create_table :employees, id: :uuid do |t|
      t.string :name
      t.datetime :date_joined
      t.string :title
      t.attachment :avatar
      t.timestamps null: false
      t.references :organisation, type: :uuid
      t.string :ancestry
    end
    add_index :employees, :ancestry

    create_table :organisations, id: :uuid do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
