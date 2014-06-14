# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  workshop_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :workshop
  counter_culture :workshop
end
