class SkillSet < ActiveRecord::Base
  has_many :employee_skills
  has_many :skills, through: :employee_skills
  belongs_to :employee

  accepts_nested_attributes_for :employee_skills, reject_if: :all_blank, allow_destroy: true

  after_save :add_empty_skill

  def add_empty_skill
    employee_skills << EmployeeSkill.new if employee_skills.empty?
  end
end
