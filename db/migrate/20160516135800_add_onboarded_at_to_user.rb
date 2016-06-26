class AddOnboardedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :onboarded_at, :datetime
  end
end
