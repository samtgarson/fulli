class UserSearch
  include Virtus.model
  include ActiveModel::Model
  include Draper::Decoratable

  attribute :display, String, default: 'table'
  attribute :query, String, default: ''
  attribute :experience, Array[String], default: []
  attribute :projects, Array[String], default: []
  attribute :interests, Array[String], default: []
  attribute :skills, Array[String], default: []
  attribute :id # organisation id
  attribute :page, Integer, default: 1
  attribute :per, Integer, default: 20
  attribute :order, String, default: 'name'
  attribute :reverse, Integer, default: 0
  attribute :except_id, String, default: ''

  validates :id, presence: true

  def self.allowed_params
    [
      :query,
      :id,
      :page,
      :per,
      :order,
      :reverse,
      :except_id,
      :display,
      {
        experience: [],
        projects: [],
        interests: [],
        skills: []
      }
    ]
  end

  def results
    @results ||= if filtered_list.is_a? Array
                   Kaminari.paginate_array(filtered_list).page(page).per(per)
                 else
                   filtered_list.page(page).per(per)
                 end
  end

  def filtered_list
    @filtered_list ||= Organisation
                       .friendly.find(id)
                       .users.onboarded
                       .all_except(except_id)
                       .search(query)
                       .has_tags(experience, :experiences)
                       .has_tags(projects, :projects)
                       .has_tags(interests, :interests)
                       .has_skills(skills)
                       .order_by_rating(skill, order_hash)
  end

  def skill
    skills.first if skills.any?
  end

  def order_hash
    Hash[order.to_sym, direction]
  end

  def direction
    reverse.to_i == 1 ? :desc : :asc
  end
end
