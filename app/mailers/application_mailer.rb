class ApplicationMailer < Devise::Mailer
  self.asset_host = nil
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  include Roadie::Rails::Automatic
end
