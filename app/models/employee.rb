class Employee < ActiveRecord::Base
  belongs_to :organisation
  has_ancestry cache_depth: true
  has_attached_file :avatar
  
  has_many :employee_skills
  has_many :skills, through: :employee_skills

  accepts_nested_attributes_for :employee_skills, reject_if: :all_blank, allow_destroy: true

  acts_as_taggable_on :experiences, :interests, :projects

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :name, :date_joined, :title, presence: true
  validates :avatar, attachment_presence: true
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}

  include PgSearch
  pg_search_scope(
    :query_search,
    against: %i(
      name
      title
    ),
    using: {
      tsearch: {
        prefix: true
      }
    }
  )

  scope :search, -> (q) { query_search(q) unless !q.nil? && q.empty? }
  scope :all_except, -> (id) { where.not(id: id) unless !id.nil? && id.empty? }

  after_save :add_empty_skill

  def slug_candidates
    [
      :name,
      [:name, :title]
    ]
  end

  def as_json(_options = {})
    {
      name: name,
      title: title,
      avatar_url: avatar.url,
      id: id,
    }
  end

  private

  def add_empty_skill
    employee_skills << EmployeeSkill.new if employee_skills.empty?
  end
end
