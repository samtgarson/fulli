class Skill < ActiveRecord::Base
  has_many :employee_skills, inverse_of: :skill
  has_many :employees, through: :employee_skill, inverse_of: :skills

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_s
    name
  end

  class << self
    def find_or_create_by_name(name)
      find_or_create_by(slug: generate_slug_for(name)) do |new_tag|
        new_tag.name = name.titleize
      end
    end

    def generate_slug_for(name)
      name.
        gsub(' and ', ' ').
        slugify(true)
    end
  end
end
