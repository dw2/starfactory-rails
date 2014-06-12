class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :student_profile
  belongs_to :instructor_profile

  VALID_STATUSES = %w(Published Locked Removed)
  DEFAULT_SORT_COLUMN = 'comments.created_at'

  delegate :name, to: :discussion, allow_nil: true

  scope :published, -> { where { status.eq 'Published' } }
  scope :locked, -> { where { status.eq 'Locked' } }
  scope :removed, -> { where { status.eq 'Removed' } }
end
