require 'rails_helper'

RSpec.feature 'Viewing an organisation' do
  let(:org) { FactoryGirl.create :organisation }
  let(:current_user) { FactoryGirl.create :user, :confirmed, organisation_ids: [org.id] }

  background do
    log_in_user
  end

  scenario 'fails when not part of the organisation' do
    current_user.update_attributes organisation_ids: []
    visit organisation_path(org)

    expect(page).to have_selector 'h2', text: 'Organisations'
    expect(page).to have_selector '.flash', text: t('flashes.not_member')
  end

  context 'as an admin' do
    background do
      current_user.promote_to(org, 'admin')
    end

    scenario 'that has no employees' do
      click_on org.name
      expect(page).to have_selector 'p', text: t('organisations.show.empty_admin', name: org.name)

      click_on 'new-employee'
      expect(page).to have_selector 'h2', text: "New Employee for #{org.name}"
    end
  end

  context 'as a user' do
    scenario 'that has no employees' do
      click_on org.name
      expect(page).to have_selector 'p', text: t('organisations.show.empty', name: org.name)
      expect(page).not_to have_selector '#wrapper .btn'
    end
  end

  context 'for everyone' do
    scenario 'that has employees' do
      FactoryGirl.create_list(:employee, 3, organisation: org)

      click_on org.name
      org.employees.each do |e|
        expect(page).to have_selector 'td', text: e.name
      end

      click_on (employee = org.employees.first).name
      expect(page).to have_selector 'h3', text: employee.name
    end
  end
end
