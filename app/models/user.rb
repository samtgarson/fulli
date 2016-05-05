class User < ActiveRecord::Base
  extend FriendlyId
  has_attached_file :avatar

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_many :organisations, through: :associations
  has_many :associations

  friendly_id :slug_candidates, use: :slugged

  validates :name, :email, presence: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def slug_candidates
    [
      :name,
      [:name, rand(10...999).to_s]
    ]
  end

  def pending_invite?
    invited_to_sign_up? && !invitation_accepted?
  end

  def admin_of?(org)
    %w(admin owner).include? associations.find_by(organisation_id: org.id).role
  end

  def owner_of?(org)
    associations.find_by(organisation_id: org.id).role == 'owner'
  end
end
