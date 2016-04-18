class EmployeeSearch
  include Virtus.model
  include ActiveModel::Model
  include Draper::Decoratable

  attribute :query, String, default: ''
  attribute :id # organisation id
  attribute :page, Integer, default: 1
  attribute :per, Integer, default: 20
  attribute :order, String, default: 'name'
  attribute :reverse, Integer, default: 0
  attribute :except_id, String, default: ''

  validates :id, presence: true

  def self.allowed_params
    attributes.map(&:name)
  end

  def results
    @results ||= Organisation
                 .friendly.find(id)
                 .employees.all_except(except_id)
                 .search(query)
                 .order(order_hash)
                 .page(page).per(per)
  end

  def order_hash
    Hash[order.to_sym, direction]
  end

  def direction
    reverse.to_i == 1 ? :desc : :asc
  end
end
