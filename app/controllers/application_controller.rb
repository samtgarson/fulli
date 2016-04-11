class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate!, except: :login
  before_action :check_for_org, except: [:login, :sign_up]

  def login

  end

  private

  def authenticate!
    redirect_to login_path unless session[:user_email].present?
  end

  def check_for_org
    redirect_to signup_path unless current_user.organisations.any?
  end

  def current_user
    @current_user ||= User.find_by(email: session[:user_email]).decorate
  end
  helper_method :current_user
end
