require 'rails_helper'

RSpec.describe User do
  describe '.has_tags' do
    let(:users) { FactoryGirl.create_list(:user, 3) }
    let(:experienced_user) { users.first }
    let(:interested_user) { users.last }

    before do
      experienced_user.update_attributes experience_list: ['Health']
      interested_user.update_attributes interest_list: ['Health']
    end

    context 'given a tag' do
      it 'returns the tagged members with a scope' do
        expect(User.has_tags 'Health', :experiences).to match_array [experienced_user]
      end

      it 'returns the tagged members with no scope' do
        expect(User.has_tags 'Health').to match_array [experienced_user, interested_user]
      end
    end

    context 'with no tag' do
      it 'returns all members' do
        expect(User.has_tags '').to match_array users
      end
    end
  end

  describe 'validations' do
    subject { FactoryGirl.create :user }

    context 'before onboarding' do
      it 'is valid with basics' do
        expect(subject).to be_valid
      end

      it 'is invalid without email or name' do
        subject.name = nil
        subject.email = ''
        expect(subject).not_to be_valid
      end
    end

    context 'after onboarding' do
      it 'is invalid with the basics' do
        subject.onboarded_at = DateTime.current
        expect(subject).not_to be_valid
      end

      it 'is valid with employement details' do
        subject.update_attributes FactoryGirl.attributes_for :user, :onboarded
        expect(subject).to be_valid
      end
    end

    context 'with no skills' do
      it 'has an empty employee skill' do
        expect(subject.employee_skills.size).to be 1
        expect(subject.employee_skills.first.skill).to be_nil
        expect(subject.employee_skills.first.rating).to be 0
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with invalid employee skills' do
      before do
        subject.employee_skills.create rating: 4
        subject.employee_skills.create skill: 'Health'
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end
    end
  end
end
