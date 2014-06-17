# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  status               :string(255)      default("Active")
#  starts_at            :datetime
#  ends_at              :datetime
#  workshop_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  cost_in_cents        :integer          default(0)
#  registrations_count  :integer          default(0)
#  registrations_max    :integer          default(0)
#  registration_ends_at :datetime
#

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
