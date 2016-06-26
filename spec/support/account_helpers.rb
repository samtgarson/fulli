module AccountHelpers
  def log_in_user
    visit root_path
    click_link t('nav.log_in')
    fill_in 'Email', with: current_user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end
end
