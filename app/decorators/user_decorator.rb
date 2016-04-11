class UserDecorator < Draper::Decorator
  delegate_all

  def nav
    helpers.content_tag :ul, id: 'nav' do
      (admin? ? admin_nav : basic_nav).map do |k, v|
        helpers.content_tag :li, do
          helpers.link_to k, v
        end
      end
    end
  end

  private

  def admin_nav
    {
      orgs: context.organisations_path,
      account: context.user_path(object),
      logout: context.logout_path
    }
  end

  def basic_nav

  end
