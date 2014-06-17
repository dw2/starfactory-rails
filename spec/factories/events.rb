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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    starts_at Time.now + 2.days + 4.hours
    ends_at Time.now + 2.days + 6.hours
    workshop
    instructor_profiles []
    registrations_max 0
  end
end
