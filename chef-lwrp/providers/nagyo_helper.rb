action :add do
  NagyoHelper.add_or_update(new_resource)

  # do we need this for notifications? should it be based on whether created 
  # new or updated existing nagyo model?
  new_resource.updated_by_last_action(true)
end
