class RenameTagsToSkills < ActiveRecord::Migration
  def change
    rename_table :tags, :skills
    rename_table :employee_tags, :employee_skills

    remove_reference :employee_skills, :tag
    add_reference :employee_skills, :skill, type: :uuid

    remove_column :skills, :scope
  end
end
