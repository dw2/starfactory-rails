# == Schema Information
#
# Table name: discussions
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  status                :string(255)      default("Active")
#  comments_count        :integer          default(0), not null
#  workshop_id           :integer
#  student_profile_id    :integer
#  instructor_profile_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#  body                  :text             default("")
#  admin_profile_id      :integer
#

class Discussion < ActiveRecord::Base
  belongs_to :workshop
  counter_culture :workshop
  belongs_to :student_profile
  belongs_to :instructor_profile
  belongs_to :admin_profile

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

  def author_name
    case
    when student_profile.present?
      student_profile.name
    when instructor_profile.present?
      instructor_profile.name
    when admin_profile.present?
      admin_profile.name
    else
      nil
    end
  end

  def last_comment
    Comment
      .where(discussion_id: id)
      .by_date.last
  end
end
