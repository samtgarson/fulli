module NavHelper
  def nav
    content_tag :ul, id: 'nav' do
      nav_links.map do |k, v|
        content_tag :li, class: ('active' if current_page?(v[:path])) do
          link_to t("nav.#{k}"), v[:path], v[:options]
        end
      end.join(' ').html_safe
    end
  end

  private

  def nav_links
    current_user ? user_nav : anon_nav
  end

  def admin_nav
    {
      orgs: { path: organisations_path },
      account: { path: user_path(current_user) },
      logout: { path: destroy_user_session_path }
    }
  end

  def anon_nav
    {
      home: { path: root_path },
      log_in: { path: new_user_session_path },
      sign_up: { path: new_user_registration_path, options: { class: 'btn' } }
    }
  end
end
