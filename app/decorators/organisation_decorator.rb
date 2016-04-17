class OrganisationDecorator < Draper::Decorator
  delegate_all
  

  def users
    object.users.decorate context: context
  end

end
