require 'rails_helper'

RSpec.feature 'Editing an organisation' do
  let(:current_user) { FactoryGirl.create :user, :confirmed, :onboarded }
  let(:new_org) { FactoryGirl.build :organisation, :with_url }
  let(:org) { FactoryGirl.create :organisation, :with_url }
  let(:other_user) { FactoryGirl.create :user, :confirmed, :onboarded }
  let(:new_user) { FactoryGirl.build :user }

  background do
    log_in_user
  end

  scenario 'can view and edit organisation settings' do
    current_user.update_attributes organisation: org, role: 'admin'
    visit edit_organisation_path(org)

    expect(page).to have_selector 'td', text: current_user.name

    fill_in 'Name', with: 'New Org Name'
    click_button 'Save'

    expect(page).to have_selector 'h2', text: 'New Org Name'
  end

  scenario 'cannot edit if not an admin' do
    current_user.update_attributes organisation: org
    visit edit_organisation_path org

    expect(page).to have_selector 'h2', text: org.name
    expect(page).to have_selector '.flash', text: t('flashes.not_authorized')
  end

  scenario 'can transfer ownership' do
    current_user.update_attributes organisation: org, role: 'owner'
    other_user.update_attributes organisation: org
    visit edit_organisation_path(org)

    expect(page).to have_selector 'h2', text: 'Transfer Ownership'
    expect(find('tr', text: current_user.name)).to have_content 'Owner'

    select other_user.name, from: 'user_id'
    click_button 'Transfer Ownership'

    expect(page).not_to have_selector 'h2', text: 'Transfer Ownership'
    expect(find('tr', text: current_user.name)).not_to have_content 'Owner'
    expect(find('tr', text: other_user.name)).to have_content 'Owner'
  end

  scenario 'can promote other users', js: true do
    current_user.update_attributes organisation: org, role: 'admin'
    other_user.update_attributes organisation: org
    click_link "Edit #{org.name}"

    click_button 'Make Admin', visible: false

    expect(find('tr', text: other_user.name)).to have_content 'Admin'
  end

  scenario 'can invite a new user who will automagically join' do
    click_link t('nav.log_out')

    email = new_user.invite!
    new_user.update_attributes organisation: org
    token = email.body.match(/invitation_token=(\w*)/)[1]
    visit accept_user_invitation_url(invitation_token: token)

    expect(page).to have_selector 'h2', text: "Join #{org.name}"

    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button t('devise.invitations.edit.submit_button')

    expect(page).to have_selector 'h2', text: t('components.profile.summary')
  end

  scenario 'can invite existing users to join' do
    current_user.update_attributes organisation: org, role: 'owner'
    visit new_user_invitation_path(organisation_id: org.slug)

    fill_in 'Email', with: other_user.email
    fill_in 'Name', with: other_user.name
    click_button t('devise.invitations.new.submit_button')

    expect(find('tr', text: other_user.name)).not_to have_selector 'td.avatar', text: 'm'
  end

  scenario 'can remove and uninvite users' do
    new_user.invite!
    new_user.update_attributes organisation: org
    other_user.update_attributes organisation: org
    current_user.update_attributes organisation: org
    current_user.promote_to('owner')

    visit edit_organisation_path(org)
    find('tr', text: /#{other_user.name}/).click_button 'b'
    expect(page).not_to have_selector 'td', text: other_user.name

    find('tr', text: /#{new_user.name}/).click_button 'b'
    expect(page).not_to have_selector 'td', text: new_user.name
  end
end
