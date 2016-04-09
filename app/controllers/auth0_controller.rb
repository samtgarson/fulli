class Auth0Controller < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :check_for_org
  
  def callback
    binding.pry
    session[:user_email] = request.env['omniauth.auth']['info']['email']
    redirect_to root_path
  end

  def failure
    @error_msg = request.params['message']
  end

end
