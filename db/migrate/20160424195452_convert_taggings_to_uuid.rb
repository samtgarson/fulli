class ConvertTaggingsToUuid < ActiveRecord::Migration
  def change
    remove_column :taggings, :taggable_id, :integer
    add_column :taggings, :taggable_id, :uuid

    add_index :taggings, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], name: 'taggings_idx', unique: true, using: :btree
    add_index :taggings, [:taggable_id, :taggable_type, :context], name: 'index_taggings_on_taggable_id_and_taggable_type_and_context', using: :btree
  end
end
