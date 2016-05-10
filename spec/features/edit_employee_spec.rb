require 'rails_helper'

RSpec.feature 'Editing an organisation' do
  let(:org) { FactoryGirl.create :organisation }
  let(:current_user) { FactoryGirl.create :user, :confirmed, organisation_ids: [org.id] }
  let(:new_employee) { FactoryGirl.attributes_for :employee }
  let(:existing_employee) { FactoryGirl.create(:employee, organisation_id: org.id) }

  background do
    current_user.promote_to(org, 'admin')
  end

  scenario 'can add a new employee' do
    log_in_user

    visit new_organisation_employee_path(org)
    expect(page).to have_selector 'h2', text: "New Employee for #{org.name}"

    fill_in 'Name', with: new_employee[:name]
    fill_in 'Position', with: new_employee[:title]
    select_date new_employee[:date_joined], from: 'employee_date_joined'
    attach_file 'Profile Picture', "#{Rails.root}/public/avatars/original/missing.png"
    click_button 'Save'

    expect(page).to have_selector 'h2', text: org.name
    expect(page).to have_selector 'td', text: new_employee[:name]
  end

  scenario 'can edit an employee', js: true do
    login_as(current_user, scope: :user)
    visit edit_organisation_employee_path(org, existing_employee)
    expect(page).to have_selector 'h3', text: /#{existing_employee.name}/i

    find('a', text: t('components.profile.skills_interests')).click
    add_tags_to_selectize '#employee_experience_list', with: %w(Hello World), create: true

    find('button', text: /Save/i)
    expect(select_value_of '#employee_experience_list').to match_array %w(Hello World)
  end
end
