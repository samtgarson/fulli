module NavHelper
  def nav
    content_tag :ul, id: 'nav' do
      nav_links.map do |k, v|
        content_tag :li, class: ('active' if current_page?(v[:path])) do
          link_to v[:raw] ? k : t("nav.#{k}"), v[:path], v[:options]
        end
      end.join(' ').html_safe
    end
  end

  private

  def nav_links
    current_user ? user_nav : anon_nav
  end

  def user_nav
    {}.tap do |h|
      h[current_user.organisation.name] = { path: organisation_path(current_user.organisation), raw: true } if current_user.organisation.present?
      h[current_user.name] = { path: edit_user_path(current_user), raw: true } if current_user.onboarded_at?
      h[:account] = { path: edit_user_registration_path }
      h[:log_out] = { path: destroy_user_session_path, options: { method: :delete } }
    end
  end

  def anon_nav
    {
      home: { path: root_path },
      log_in: { path: new_user_session_path },
      sign_up: { path: new_user_registration_path, options: { class: 'btn' } }
    }
  end
end
