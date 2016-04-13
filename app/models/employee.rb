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
        dictionary: "english",
        prefix: true
      }
    }
  )

  scope :search, -> (q) { q.empty? ? order(:name) : query_search(q) }
  scope :all_except, -> (id) { id.empty? ? order(:name) : where.not(id: id) }

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
