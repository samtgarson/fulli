class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home

  end

  private

  def current_user
    @current_user ||= User.find_by(email: session[:user_email])
  end
  helper_method :current_user
end
