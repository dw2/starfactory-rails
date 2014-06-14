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
#

class Registration < ActiveRecord::Base
  belongs_to :event
  counter_culture :event
  belongs_to :student_profile

  VALID_STATUSES = %w(Pending Complete Passed)
  DEFAULT_SORT_COLUMN = 'registrations.status'

  scope :pending, -> { where { status.eq 'Pending' } }
  scope :complete, -> { where { status.eq 'Complete' } }
  scope :passed, -> { where { status.eq 'Passed' } }

  delegate :id, to: :event, prefix: true
  delegate :id, to: :student_profile, prefix: true
  delegate :name, to: :student_profile, prefix: true
  delegate :workshop, to: :event, prefix: true
  delegate :workshop_name, to: :event, prefix: true
  delegate :starts_at, to: :event, prefix: true
  delegate :ends_at, to: :event, prefix: true
  delegate :smart_length, to: :event, prefix: true
  delegate :instructor_profiles, to: :event, prefix: true

  validates_uniqueness_of :student_profile_id, scope: :event_id

  def amount_paid_in_dollars
    amount_paid_in_cents.to_d / 100.0
  end

  def amount_paid_in_dollars=(val)
    self.amount_paid_in_cents = (val.to_d * 100).to_i
  end

  def formatted_amount_paid
    ActionController::Base.helpers.number_to_currency(
      amount_paid_in_dollars, precision: 2, locale: :en)
  end

  def formatted_amount_due
    ActionController::Base.helpers.number_to_currency(
      event.cost_in_dollars - amount_paid_in_dollars, precision: 2, locale: :en)
  end
end
