class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: :home
  before_action :check_org, except: :home, unless: :devise_controller?
  before_action :check_attributes, except: :home, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_admin, unless: :devise_controller?

  def home
  end

  protected

  def current_user
    UserDecorator.decorate(super, context: self) unless super.nil?
  end
  helper_method :current_user

  def page
    (params[:page] || 1).to_i
  end

  def after_sign_in_path_for(resource)
    if request.referer == new_user_session_url || new_user_registration_url
      current_user.organisation.present? ? organisation_path(current_user.organisation) : edit_user_path(current_user) 
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :name, :avatar)
    end

    devise_parameter_sanitizer.for(:invite).concat [:name]
  end

  def check_org
    return unless user_signed_in? && current_user.organisation_id.nil?
    flash[:notice] = 'You need to create an organisation before doing that.'
    redirect_to(new_organisation_path, status: 303)
  end

  def check_attributes
    return unless user_signed_in? && current_user.onboarded_at.nil?
    flash[:notice] = 'You need to create your profile before doing that.'
    redirect_to(edit_user_path(current_user), status: 303)
  end

  def organisation
    @organisation ||= current_user && current_user.organisation.present? ? current_user.organisation.decorate(context: self) : Organisation.new.decorate(context: self)
  end
  helper_method :organisation

  def back(label, url)
    @back = { label: label, url: url }
  end
  helper_method :back

  def set_admin
    @admin = current_user && current_user.admin?
  end

  def only_admins!
    unless @admin
      flash[:notice] = I18n.t('flashes.not_authorized')
      return redirect_to organisation_path(organisation)
    end
  end
end
