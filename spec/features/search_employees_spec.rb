require 'rails_helper'

RSpec.feature 'Searching employees' do
  let(:current_user) { FactoryGirl.create :user, :confirmed, organisation_ids: [org.id] }
  let(:org) { FactoryGirl.create :organisation }
  let!(:homer) { FactoryGirl.create(:employee, organisation_id: org.id, employee_skills_attributes: [{ skill: 'Fencing', rating: 2 }], name: 'Homer Simpson') }
  let!(:marge) { FactoryGirl.create(:employee, organisation_id: org.id, employee_skills_attributes: [{ skill: 'Fencing', rating: 5 }], name: 'Marge Simpson') }

  scenario 'can filter employees by skill', js: true do
    login_as(current_user, scope: :user)
    visit organisation_path(org)

    expect(page).to have_selector 'td', text: marge.name
    expect(page).to have_selector 'td', text: homer.name
    expect(homer.name).to appear_before marge.name

    add_tags_to_selectize '#skills', with: ['Fencing']

    expect(page).to have_selector 'th', text: /Fencing Rating/i
    expect(page).to have_field 'rating', with: 2, visible: false
    expect(page).to have_field 'rating', with: 5, visible: false
    expect(marge.name).to appear_before homer.name
  end

  scenario 'can sort employees', js: true do
    login_as(current_user, scope: :user)
    visit organisation_path(org)

    expect(page).to have_selector 'td', text: marge.name
    expect(homer.name).to appear_before marge.name

    find('th a', text: /name/i).click

    wait_for_ajax
    expect(marge.name).to appear_before homer.name
  end

  scenario 'can view organisation chart', js: true do
    homer.update_attributes parent_id: marge.id
    login_as(current_user, scope: :user)
    visit organisation_path(org)

    expect(page).to have_selector 'td', text: marge.name

    click_on 'g'

    expect(page).to have_selector '.graph canvas'
  end
end
