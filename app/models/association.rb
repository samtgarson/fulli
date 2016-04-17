class Association < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :organisation, dependent: :destroy
end
