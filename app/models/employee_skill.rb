class EmployeeSkill < ActiveRecord::Base
  belongs_to :employee, inverse_of: :employee_skills
  belongs_to :skill, inverse_of: :employee_skills

  validates :skill, presence: true, if: :rating?
  validates :rating, presence: true, if: 'skill.present?'

  def skill=(name)
    super Skill.find_or_create_by_name(name) unless name.empty?
  end
end
