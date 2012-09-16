# Ensure that at least one of the specified fields is present
# Use the :fields option to control the list of validated fields.
#
# Example to ensure that either Host or Hostgroup is present:
#     validates_with EitherOrValidator, :fields => [:host, :hostgroup]
#

class EitherOrValidator < ActiveModel::Validator

  def validate(record)
    fields = options[:fields] || []
    success = false
    fields.each do |f|
      success = true unless record.send(f).blank?
    end
    unless success
      field_names = fields.map(&:to_s).map(&:humanize).join(' or ')
      record.errors[:base] = "At least one of #{field_names} must be specified."
    end
  end

end

