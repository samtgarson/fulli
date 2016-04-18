class EmployeeSkill < ActiveRecord::Base
  belongs_to :skill_set
  belongs_to :skill

  def skill=(name)
    super Skill.find_or_create_by_name(name)
  end

end
