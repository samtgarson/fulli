class OrganisationDecorator < Draper::Decorator
  delegate_all

  def transfer_options
    helpers.options_from_collection_for_select transfer_users, 'id', 'name'
  end

  def transfer_users
    object.users.where.not(id: helpers.current_user.id)
  end

  def users
    object.users.decorate context: context
  end
end
