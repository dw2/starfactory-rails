# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :string(255)
#  latitude     :float
#  longitude    :float
#  events_count :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Location < ActiveRecord::Base
  has_many :events

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  DEFAULT_SORT_COLUMN = 'locations.name'

  def google_maps_url
    string = Rack::Utils.escape "#{name}+#{address}".gsub(/\s+/, '+')
    "http://maps.google.com/?q=#{string}"
  end
end
