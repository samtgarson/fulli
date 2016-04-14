class EmployeeSearch
  include SimpleFormObject
  include Draper::Decoratable

  attribute :query, :string, default: ''
  attribute :id
  attribute :page, :integer, default: 1
  attribute :per, :integer, default: 20
  attribute :order, :string, default: 'name'
  attribute :reverse, :integer, default: 0
  attribute :except_id, :string, default: ''

  validates :id, presence: true

  def self.allowed_params
    _attributes.map(&:name)
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
