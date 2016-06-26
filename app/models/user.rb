class User < ActiveRecord::Base
  extend FriendlyId
  include PgSearch

  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  has_attached_file :avatar
  belongs_to :organisation
  has_many :employee_skills, dependent: :destroy
  has_many :skills, through: :employee_skills
  has_ancestry cache_depth: true

  accepts_nested_attributes_for :employee_skills, reject_if: :all_blank, allow_destroy: true

  acts_as_taggable_on :experiences, :interests, :projects

  friendly_id :slug_candidates, use: :slugged

  validates :name, :email, :avatar, presence: true
  validates :title, :date_joined, presence: { allow_blank: false }, if: :onboarded_at?
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}
  validates_associated :employee_skills

  after_save :add_empty_skill

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

  scope :onboarded, -> { where.not(onboarded_at: nil) }
  scope :search, -> (q) { query_search(q) unless !q.nil? && q.empty? }
  scope :all_except, -> (id) { where.not(id: id) unless !id.nil? && id.empty? }
  scope :has_tags, -> (arr = '', scope = nil) { tagged_with(arr, (scope ? { on: scope } : {})) unless arr.empty? }
  scope :has_skills, -> (arr) { joins(:skills).where(skills: { name: arr }) unless arr.empty? }
  scope :order_by_rating, (lambda do |name, fallback|
    if name.nil?
      order(fallback)
    else
      all.to_a.uniq.sort_by { |e| e.rating_for_skill(name) }.reverse
    end
  end)

  def as_json(_options = {})
    {
      name: name,
      title: title,
      avatar_url: avatar.url,
      id: id
    }
  end

  def slug_candidates
    [
      :name,
      [:name, rand(10...999).to_s]
    ]
  end

  def send_reset_password_instructions
    super if invitation_token.nil?
  end

  def pending_invite?
    invited_to_sign_up? && !invitation_accepted?
  end

  def promote_to(role = 'admin')
    update_attributes role: role
  end

  def admin?
    %w(admin owner).include? role
  end

  def owner?
    role == 'owner'
  end

  def rating_for_skill(name)
    employee_skills.joins(:skill).find_by(skills: { name: name }).rating
  end

  private

  def add_empty_skill
    employee_skills << EmployeeSkill.new while employee_skills.count < 2
  end
end
