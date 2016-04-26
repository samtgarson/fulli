class AddIdToAssociations < ActiveRecord::Migration
  def change
    drop_table :associations

    create_table :associations, id: :uuid do |t|
      t.boolean :admin, default: false
      t.references :user, type: :uuid, index: true
      t.references :organisation, type: :uuid, index: true
    end
    add_index :associations, [:user_id, :organisation_id], unique: true
  end
end
