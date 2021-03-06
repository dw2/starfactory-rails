# == Schema Information
#
# Table name: workshops
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :text
#  status            :string(255)      default("Active")
#  banner            :string(255)
#  icon              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  votes_count       :integer          default(0)
#  votes_goal        :integer          default(0)
#  track_id          :integer
#  discussions_count :integer          default(0), not null
#  sort              :integer          default(0)
#

class Workshop < ActiveRecord::Base
  include Votable

  belongs_to :track
  has_many :events

  VALID_STATUSES = %w(Active Disabled)
  DEFAULT_SORT_COLUMN = 'tracks.name'

  include Discussionable

  scope :active, -> {
    includes(:track)
    .where { status.eq('Active') & track.status.eq('Active') }
  }
  scope :by_name, -> { order('workshops.name asc') }
  scope :by_sort, -> { order('workshops.sort asc') }
  scope :voted, -> {
    includes(:events)
    .where( events: { status: [nil, 'Disabled'] })
    .order('votes_count desc')
  }

  delegate :name, to: :track, prefix: true
  delegate :status, to: :track, prefix: true


  def snippet
    ActionController::Base.helpers.truncate(
      ActionController::Base.helpers.strip_tags(description),
      length: 30, separator: ' ')
  end
end
