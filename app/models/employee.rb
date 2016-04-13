class Employee < ActiveRecord::Base
  belongs_to :organisation
  has_ancestry
  has_attached_file :avatar

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :name, :date_joined, :title, presence: true
  validates :avatar, attachment_presence: true
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}

  def slug_candidates
    [
      :name,
      [:name, :title]
    ]
  end

end
