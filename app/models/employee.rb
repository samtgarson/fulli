class Employee < ActiveRecord::Base
  belongs_to :organisation
  has_ancestry
  has_attached_file :avatar

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

  scope :search, -> (q) { query_search(q) unless q.empty? }
  scope :all_except, -> (id) { where.not(id: id) unless id.empty? }

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
      id: id
    }
  end
end
