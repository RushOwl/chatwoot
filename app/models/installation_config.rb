# == Schema Information
#
# Table name: installation_configs
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  serialized_value :jsonb            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_installation_configs_on_name_and_created_at  (name,created_at) UNIQUE
#
class InstallationConfig < ApplicationRecord
  serialize :serialized_value, HashWithIndifferentAccess

  validates :name, presence: true

  default_scope { order(created_at: :desc) }

  def value
    serialized_value[:value]
  end

  def value=(value_to_assigned)
    self.serialized_value = {
      value: value_to_assigned
    }.with_indifferent_access
  end
end
