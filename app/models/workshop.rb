# == Schema Information
#
# Table name: workshops
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  status      :string(255)      default("Active")
#  banner      :string(255)
#  icon        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  votes_count :integer          default(0)
#  votes_goal  :integer          default(0)
#

class Workshop < ActiveRecord::Base
  include Votable

  belongs_to :track
  has_many :events

  VALID_STATUSES = %w(Active Disabled)
  DEFAULT_SORT_COLUMN = 'tracks.name'

  scope :active, -> { where { status.eq 'Active' } }
  scope :by_name, -> { order('name asc') }
  scope :voted, -> {
    includes(:events)
    .where( events: { id: nil })
    .order('votes_count desc')
  }

  delegate :name, to: :track, prefix: true
end
