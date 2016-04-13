class Organisation < ActiveRecord::Base
  has_many :employees
  has_many :users, through: :associations
  has_many :associations

  validates :name, presence: true, uniqueness: true
  validates :url, format: {:with => URI.regexp}

  extend FriendlyId
  friendly_id :name, use: :slugged

  def url=(new_url)
    new_url = "http://#{new_url}" if URI(new_url).scheme.nil?
    write_attribute(:url, new_url)
  end

  def top_employees
    employees.order(:name).limit(5)
  end
end
