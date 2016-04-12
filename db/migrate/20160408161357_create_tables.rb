class CreateTables < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string :name
      t.boolean :admin, default: false, null: false
      t.string :email
      t.attachment :avatar
      t.timestamps null: false
    end
    add_index :users, :email, unique: true

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

    create_table :organisations_users, id: false do |t|
      t.references :user, type: :uuid, index: true
      t.references :organisation, type: :uuid, index: true
    end
    add_index :organisations_users, [:user_id, :organisation_id], unique: true

    create_table :organisations, id: :uuid do |t|
      t.string :name
      t.string :allowed_domains, array: true, default: []
      t.string :slug
      t.timestamps null: false
    end
    add_index :organisations, :slug, unique: true
  end
end
