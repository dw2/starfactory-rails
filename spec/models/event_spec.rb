# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  status      :string(255)      default("Active")
#  starts_at   :datetime
#  ends_at     :datetime
#  workshop_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
