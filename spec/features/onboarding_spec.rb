require 'rails_helper'

RSpec.feature 'During onboarding' do
  let(:org) { FactoryGirl.create :organisation }
  let(:current_user) { FactoryGirl.create :user, :confirmed }
  let(:existing_user) { FactoryGirl.create :user, :confirmed, :onboarded }
  let(:org_attributes) { FactoryGirl.attributes_for :organisation }
  let(:user_attributes) { FactoryGirl.attributes_for :user, :onboarded, organisation: org }

  scenario 'the user is forced to onboard' do
    log_in_user
    expect(page).to have_selector 'h2', text: 'New Organisation'

    fill_in_org_form
    expect(page).to have_selector 'h2', text: t('components.profile.summary')

    fill_in_profile_form
    expect(page).to have_selector 'h2', text: org_attributes[:name]
  end

  scenario 'the user must fill in required fields' do
    log_in_user
    expect(page).to have_selector 'h2', text: 'New Organisation'

    fill_in_org_form
    expect(page).to have_selector 'h2', text: t('components.profile.summary')

    fill_in 'Name', with: user_attributes[:name]
    select_date user_attributes[:date_joined], from: 'user_date_joined'
    click_button 'Save'
    expect(page).to have_selector '.flash', text: I18n.t('flashes.something_wrong')

    click_button 'Save'
    expect(page).to have_selector '.flash', text: I18n.t('flashes.something_wrong')

    fill_in I18n.t('simple_form.labels.user.title'), with: user_attributes[:title]
    click_button 'Save'
    expect(page).to have_selector 'h2', text: org_attributes[:name]
  end

  scenario 'the user can go back and edit their profile', js: true do
    current_user.update_attributes user_attributes
    login_as(current_user, scope: :user)
    visit edit_user_path(current_user)
    expect(page).to have_selector 'h3', text: /#{current_user.name}/i

    find('a', text: t('components.profile.skills_interests')).click
    add_tags_to_selectize '#user_experience_list', with: %w(Hello World), create: true

    find('button', text: /Save/i)
    expect(select_value_of '#user_experience_list').to match_array %w(Hello World)
  end

  scenario 'the user cannot edit someone elses profile' do
    current_user.update_attributes user_attributes
    login_as(current_user, scope: :user)
    visit edit_user_path(existing_user)

    expect(page).to have_selector 'h2', text: org.name
  end

  def fill_in_org_form
    fill_in I18n.t('simple_form.labels.organisation.name'), with: org_attributes[:name]
    fill_in I18n.t('simple_form.labels.organisation.url'), with: org_attributes[:url]
    click_button 'Create Organisation'
  end

  def fill_in_profile_form
    fill_in I18n.t('simple_form.labels.user.name'), with: user_attributes[:name]
    fill_in I18n.t('simple_form.labels.user.title'), with: user_attributes[:title]
    select_date user_attributes[:date_joined], from: 'user_date_joined'
    click_button 'Save'
  end
end
