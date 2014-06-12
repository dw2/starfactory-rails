class Discussion < ActiveRecord::Base
  belongs_to :workshop
  belongs_to :student_profile
  belongs_to :instructor_profile

  VALID_STATUSES = %w(Active Locked Sticky)
  DEFAULT_SORT_COLUMN = 'discussions.created_at'
  DEFAULT_SORT_DIRECTION = 'desc'

  include Commentable

  scope :active, -> { where { status.eq 'Active' } }
  scope :locked, -> { where { status.eq 'Locked' } }
  scope :sticky, -> { where { status.eq 'Sticky' } }

  delegate :name, to: :workshop, prefix: true
  delegate :track, to: :workshop, prefix: true
  delegate :track_name, to: :workshop, prefix: true
end
