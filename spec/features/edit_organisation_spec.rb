require 'rails_helper'

RSpec.feature 'Editing an organisation' do
  let(:current_user) { FactoryGirl.create :user, :confirmed }
  let(:new_org) { FactoryGirl.build :organisation, :with_url }
  let(:org) { FactoryGirl.create :organisation, :with_url }
  let(:other_user) { FactoryGirl.create :user, :confirmed }
  let(:new_user) { FactoryGirl.build :user }

  background do
    log_in_user
  end

  scenario 'can create a new organisation' do
    click_on 'New Organisation'
    expect(page).to have_selector 'h2', text: 'New Organisation'

    fill_in 'Name', with: new_org.name
    fill_in 'Url', with: new_org.url
    click_button 'Create Organisation'

    expect(page).to have_selector 'h2', text: "New Employee for #{new_org.name}"
  end

  scenario 'can view and edit organisation settings' do
    current_user.organisations << org
    current_user.promote_to org, 'admin'
    visit edit_organisation_path(org)

    expect(page).to have_selector 'td', text: current_user.name

    fill_in 'Name', with: 'New Org Name'
    click_button 'Save'

    expect(page).to have_selector 'h2', text: 'New Org Name'
  end

  scenario 'cannot edit if not an admin' do
    current_user.organisations << org
    visit edit_organisation_path org

    expect(page).to have_selector 'h2', text: org.name
    expect(page).to have_selector '.flash', text: t('flashes.not_authorized')
  end

  scenario 'can transfer ownership' do
    current_user.organisations << org
    current_user.promote_to org, 'owner'
    other_user.organisations << org
    visit edit_organisation_path(org)

    expect(page).to have_selector 'h2', text: 'Transfer Ownership'
    expect(find('tr', text: current_user.name)).to have_content 'Owner'

    select other_user.name, from: 'user_id'
    click_button 'Transfer Ownership'

    expect(page).not_to have_selector 'h2', text: 'Transfer Ownership'
    expect(find('tr', text: current_user.name)).not_to have_content 'Owner'
    expect(find('tr', text: other_user.name)).to have_content 'Owner'
  end

  scenario 'can promote other users' do
    current_user.organisations << org
    current_user.promote_to org, 'admin'
    other_user.organisations << org
    visit edit_organisation_path(org)

    click_button 'Make Admin', visible: false

    expect(find('tr', text: other_user.name)).to have_content 'Admin'
  end

  scenario 'can invite a new user who will automagically join' do
    current_user.organisations << org
    current_user.promote_to org, 'owner'
    visit new_user_invitation_path(organisation_id: org.slug)

    expect(page).to have_selector 'h2', text: t('devise.invitations.new.title', name: org.name)

    clear_emails
    fill_in 'Email', with: new_user.email
    fill_in 'Name', with: new_user.name
    click_button t('devise.invitations.new.submit_button')
    expect(page).to have_selector 'td', text: new_user.name

    open_email new_user.email
    current_email.click_link t('devise.mailer.invitation_instructions.accept')

    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button t('devise.invitations.edit.submit_button')

    expect(page).to have_selector 'td', text: org.name
  end

  scenario 'can invite existing users to join' do
    current_user.organisations << org
    current_user.promote_to org, 'owner'
    visit new_user_invitation_path(organisation_id: org.slug)

    fill_in 'Email', with: other_user.email
    fill_in 'Name', with: other_user.name
    click_button t('devise.invitations.new.submit_button')

    expect(find('tr', text: other_user.name)).not_to have_selector 'td.avatar', text: 'm'
  end

  scenario 'can remove and uninvite users' do
    new_user.invite!
    new_user.update_attributes organisations: [org]
    other_user.organisations << org
    current_user.organisations << org
    current_user.promote_to org, 'owner'

    visit edit_organisation_path(org)
    find('tr', text: /#{other_user.name}/).click_button 'b'
    expect(page).not_to have_selector 'td', text: other_user.name

    find('tr', text: /#{new_user.name}/).click_button 'b'
    expect(page).not_to have_selector 'td', text: new_user.name
  end
end
