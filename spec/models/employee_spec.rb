require 'rails_helper'

RSpec.describe Employee do
  describe '.has_tags' do
    let(:employees) { FactoryGirl.create_list(:employee, 3) }
    let(:experienced_employee) { employees.first }
    let(:interested_employee) { employees.last }

    before do
      experienced_employee.update_attributes experience_list: ['Health']
      interested_employee.update_attributes interest_list: ['Health']
    end

    context 'given a tag' do
      it 'returns the tagged members with a scope' do
        expect(Employee.has_tags 'Health', :experiences).to match_array [experienced_employee]
      end

      it 'returns the tagged members with no scope' do
        expect(Employee.has_tags 'Health').to match_array [experienced_employee, interested_employee]
      end
    end

    context 'with no tag' do
      it 'returns all members' do
        expect(Employee.has_tags '').to match_array employees
      end
    end
  end

  describe 'validations' do
    subject { FactoryGirl.create :employee }

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
