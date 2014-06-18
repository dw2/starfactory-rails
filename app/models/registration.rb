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

  before_save :update_status_by_amount_due

  VALID_STATUSES = %w(Pending Paid)
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
  delegate :cost_in_cents, to: :event, prefix: true

  validates_uniqueness_of :student_profile_id, scope: :event_id
  validate :event_starts_at_cannot_be_in_the_past

  def event_starts_at_cannot_be_in_the_past
    if event.starts_at < Time.now
      errors.add(:base, "You can't register for past events.")
    end
  end

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

  def amount_due
    event.cost_in_dollars - amount_paid_in_dollars
  end

  def formatted_amount_due
    ActionController::Base.helpers.number_to_currency(
      amount_due, precision: 2, locale: :en)
  end

private

  def update_status_by_amount_due
    if amount_due > 0
      self.status = 'Pending'
    else
      self.status = 'Paid'
    end
  end
end
