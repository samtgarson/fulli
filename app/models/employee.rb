class Employee < ActiveRecord::Base
  belongs_to :organisation
  has_ancestry
end
