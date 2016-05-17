class Organisation < ActiveRecord::Base
  has_many :users, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :url, format: { with: URI.regexp }, allow_blank: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def allowed_domains=(list)
    super list.split(',')
  end

  def url=(new_url)
    new_url = "http://#{new_url}" if URI(new_url).scheme.nil?
    super new_url
  end

  def top_employees
    users.order(:name).limit(5)
  end
end
