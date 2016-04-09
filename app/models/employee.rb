class Employee < ActiveRecord::Base
  belongs_to :organisation
  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :name, :date_joined, :title, presence: true

  def slug_candidates
    [
      :name,
      [:name, :title]
    ]
  end

end
