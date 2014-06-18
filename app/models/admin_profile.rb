# == Schema Information
#
# Table name: admin_profiles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class AdminProfile < ActiveRecord::Base
  belongs_to :user, inverse_of: :admin_profile
  delegate :email, to: :user, allow_nil: true

  DEFAULT_SORT_COLUMN = 'admin_profiles.name'

  validates_presence_of :name
  validates_presence_of :user
end
