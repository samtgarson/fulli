class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: :home
  before_action :check_access_to_org, except: :home, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_admin, unless: :devise_controller?

  def home
  end

  protected

  def page
    (params[:page] || 1).to_i
  end

  def check_access_to_org
    unless current_user.organisation_ids.include? organisation.id
      flash[:notice] = 'You are not part of this organisation yet.'
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render :nothing, status: 401 }
      end
    end
  end

  def after_sign_in_path_for(resource)
    if request.referer == new_user_session_url || new_user_registration_url
      organisations_path
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

  def organisation
    @organisation ||= if (id = params[:organisation_id] || params[:id])
                        Organisation.friendly.find(id).decorate context: self
                      else
                        Organisation.new.decorate context: self
                      end
  end
  helper_method :organisation

  def back(label, url)
    @back = { label: label, url: url }
  end
  helper_method :back

  def set_admin
    @admin = current_user && current_user.admin_of?(organisation)
  end

  def only_admins!
    unless @admin
      flash[:notice] = 'You are not authorized to access that page.'
      redirect_to organisation_path(organisation)
    end
  end
end
