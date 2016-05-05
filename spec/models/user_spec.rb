require 'rails_helper'

RSpec.describe User do
  let(:org) { FactoryGirl.create :organisation }
  let(:other_org) { FactoryGirl.create :organisation }
  let(:user) { FactoryGirl.create :user }
  let(:association) { Association.create user: user, organisation: org }
  let!(:other_association) { Association.create user: user, organisation: other_org }

  describe '#admin_of?' do
    before do
      association.update_attributes role: 'admin'
    end

    it 'returns the correct value' do
      expect(user.admin_of? org).to be_truthy
      expect(user.admin_of? other_org).not_to be_truthy
    end
  end

  describe '#owner_of?' do
    before do
      association.update_attributes role: 'owner'
    end

    it 'returns the correct value' do
      expect(user.owner_of? org).to be_truthy
      expect(user.owner_of? other_org).not_to be_truthy
    end
  end
end
