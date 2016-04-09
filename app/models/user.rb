class User < ActiveRecord::Base
  has_and_belongs_to_many :organisations

  validates :organisation, presence: true, unless: :admin?
end
