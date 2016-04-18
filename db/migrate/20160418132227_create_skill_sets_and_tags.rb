class CreateSkillSetsAndTags < ActiveRecord::Migration
  def change
    create_table :skill_sets, id: :uuid do |t|
      t.references :employee, type: :uuid
      t.timestamps null: false
    end

    create_table :tags, id: :uuid do |t|
      t.string :name
      t.string :slug, index: true, unique: true
      t.string :scope
      t.timestamps null: false
    end

    create_table :employee_tags, id: :uuid do |t|
      t.references :skill_set, type: :uuid
      t.references :tag, type: :uuid
      t.integer :rating, default: 0
      t.timestamps null: false
    end
  end
end
