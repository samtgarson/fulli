require 'rails_helper'

RSpec.describe UserSearch do
  attr_list = [
    {
      name: 'Homer',
      title: 'CEO',
      experience_list: %w(Health Finance)
    },
    {
      name: 'Marge',
      experience_list: %w(Health),
      interest_list: %w(Health),
      employee_skills_attributes: [{ skill: 'Fencing', rating: 2 }]
    },
    {
      name: 'Bart',
      employee_skills_attributes: [{ skill: 'Fencing', rating: 5 }]
    },
    {
      name: 'Lisa'
    }
  ]

  let(:org) { FactoryGirl.create :organisation }
  attr_list.each do |attrs|
    let!(attrs[:name].downcase.to_sym) { FactoryGirl.create(:user, :onboarded, :confirmed, { organisation_id: org.id }.merge(attrs)) }
  end

  describe '.results' do
    test_list = [
      {
        desc: 'given one tag',
        args: { experience: ['Health'] },
        result: [:homer, :marge]
      },
      {
        desc: 'given one tag and reverse',
        args: { experience: ['Health'], reverse: 1 },
        result: [:marge, :homer]
      },
      {
        desc: 'given a search query',
        args: { query: 'CEO' },
        result: [:homer]
      },
      {
        desc: 'given a query and a tag',
        args: { interests: ['Health'], query: 'marg' },
        result: [:marge]
      },
      {
        desc: 'given a skill',
        args: { skills: ['Fencing'] },
        result: [:bart, :marge]
      },
      {
        desc: 'given a skill and a tag',
        args: { skills: ['Fencing'], interests: ['Health'] },
        result: [:marge]
      },
      {
        desc: 'given a blank search query',
        args: { query: '' },
        result: [:bart, :homer, :lisa, :marge]
      }
    ]

    test_list.each do |test|
      context test[:desc] do
        let(:search) { UserSearch.new(test[:args].merge(id: org.id)) }

        it 'returns the correct users in the correct order' do
          expect(search.results).to eq test[:result].map { |m| public_send m }
        end
      end
    end
  end
end
