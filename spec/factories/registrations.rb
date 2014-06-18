# == Schema Information
#
# Table name: registrations
#
#  id                   :integer          not null, primary key
#  event_id             :integer
#  student_profile_id   :integer
#  status               :string(255)      default("Pending")
#  created_at           :datetime
#  updated_at           :datetime
#  amount_paid_in_cents :integer          default(0)
#  stripe_token         :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration do
  end
end
