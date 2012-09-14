# Ensure that at least one of :host or :hostgroup is set
#
class HostOrHostgroupValidator < ActiveModel::Validator

  # 
  def validate(record)
    unless record.host.present? or record.hostgroup.present?
      record.errors[:base] = "At least one of Host or Hostgroup must be specified."
    end
  end

end

