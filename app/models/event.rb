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
#  location_id          :integer
#

class Event < ActiveRecord::Base
  belongs_to :workshop
  has_many :instructor_profiles_events
  has_many :instructor_profiles, through: :instructor_profiles_events
  has_many :registrations
  has_many :student_profiles, through: :registrations
  belongs_to :location
  counter_culture :location

  VALID_STATUSES = %w(Active Disabled)
  DEFAULT_SORT_COLUMN = 'events.starts_at'

  scope :active, -> { where { status.eq 'Active' } }
  scope :upcoming, -> { where { starts_at.gteq Time.now } }
  scope :current, -> { where { ends_at.gt Time.now } }
  scope :passed, -> { where { ends_at.lt Time.now } }
  scope :ongoing, -> { where { (starts_at.lteq Time.now) & (ends_at.gteq Time.now) } }
  scope :by_soonest, -> { order('events.starts_at asc') }
  scope :registered, -> {
    includes(:registrations)
    .where( registrations: { id: nil })
    .order('events.registrations_count desc')
  }

  delegate :name, to: :workshop, prefix: true
  delegate :description, to: :workshop, prefix: true
  delegate :track_name, to: :workshop, prefix: true
  delegate :name, to: :location, prefix: true, allow_nil: true
  delegate :address, to: :location, prefix: true, allow_nil: true
  delegate :google_maps_url, to: :location, prefix: true, allow_nil: true

  def cost_in_dollars
    cost_in_cents.to_d / 100.0
  end

  def cost_in_dollars=(val)
    self.cost_in_cents = (val.to_d * 100).to_i
  end

  def formatted_cost
    if cost_in_dollars <= 0
      'Free'
    elsif cost_in_dollars.to_i < cost_in_dollars
      ActionController::Base.helpers.number_to_currency(
        cost_in_dollars, precision: 2, locale: :en)
    else
      "$#{cost_in_dollars.to_i}"
    end
  end

  def smart_length
    hours = (ends_at - starts_at) / 3600
    if hours < 24
      ActionController::Base.helpers.pluralize(
        ("%g" % ("%.2f" % hours)), 'hour', 'hours')
    else
      days = (hours / 24).ceil
      ActionController::Base.helpers.pluralize(
        ("%g" % ("%.2f" % days)), 'day', 'days')
    end
  end

  def spots_left
    spots = registrations_max - registrations_count
    spots = 0 if spots < 0
    spots
  end

  def passed?
    ends_at < Time.now
  end

  def registration_closed?
    now_time = Time.now + Time.now.in_time_zone('Pacific Time (US & Canada)').utc_offset.seconds
    reg_time = registration_ends_at.present? ? registration_ends_at : starts_at
    spots_left == 0 || reg_time < now_time
  end

  %w(starts_at ends_at registration_ends_at).each do |x|
    define_method "#{x}_day" do
      send(x).present? ? send(x).strftime('%Y-%m-%d') : ''
    end

    define_method "#{x}_day=" do |val|
      time = send("#{x}_time")
      self.send("#{x}=", DateTime.parse(val + ' ' + time)) if time.present?
    end

    define_method "#{x}_time" do
      send(x).present? ? send(x).strftime('%H:%M') : ''
    end

    define_method "#{x}_time=" do |val|
      day = send("#{x}_day")
      self.send("#{x}=", DateTime.parse(day + ' ' + val)) if day.present?
    end
  end
end
