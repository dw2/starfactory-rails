# == Schema Information
#
# Table name: coupons
#
#  id              :integer          not null, primary key
#  code            :string(255)
#  description     :string(255)
#  amount_in_cents :integer          default(0)
#  expires_at      :datetime
#  event_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Coupon < ActiveRecord::Base
  belongs_to :event

  DEFAULT_SORT_COLUMN = 'coupons.code'

  validates_presence_of :code
  validates_uniqueness_of :code, scope: :event

  scope :by_code, -> { order('coupons.code asc') }
  scope :by_amount, -> { order('coupons.amount_in_cents desc') }

  delegate :workshop_name, to: :event, prefix: true
  delegate :starts_at, to: :event, prefix: true

  def code= code
    super(code.try(:upcase))
  end

  def amount_in_dollars
    amount_in_cents.to_d / 100.0
  end

  def amount_in_dollars=(val)
    self.amount_in_cents = (val.to_d * 100).to_i
  end

  def formatted_amount
    if amount_in_dollars.to_i < amount_in_dollars
      ActionController::Base.helpers.number_to_currency(
        amount_in_dollars, precision: 2, locale: :en)
    else
      "$#{amount_in_dollars.to_i}"
    end
  end
end
