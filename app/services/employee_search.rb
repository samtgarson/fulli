class EmployeeSearch
  include SimpleFormObject

  attribute :query
  attribute :organisation_id
  attribute :page, :integer, default: 1
  attribute :per, :integer, default: 20
  attribute :subtract

  validates :organisation_id, presence: true

  def results
    Organisation.friendly.find(organisation_id).employees.all_except(except_id).search(query).order(:name).page(page).per(per)
  end
end
