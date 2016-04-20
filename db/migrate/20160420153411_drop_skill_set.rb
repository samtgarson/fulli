class DropSkillSet < ActiveRecord::Migration
  def change
    remove_reference :employee_skills, :skill_set
    add_reference :employee_skills, :employee, type: :uuid
    
    drop_table :skill_sets
  end
end
