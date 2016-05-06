module AccountHelpers
  def log_in_user
    visit organisations_path
    fill_in 'Email', with: current_user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end
end
