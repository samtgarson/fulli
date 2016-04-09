class Organisation < ActiveRecord::Base
  has_many :employees
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
