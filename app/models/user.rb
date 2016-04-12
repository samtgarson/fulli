class User < ActiveRecord::Base
  extend FriendlyId
  has_attached_file :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_and_belongs_to_many :organisations

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, rand(10...999).to_s]
    ]
  end

  validates :name, :email, presence: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
