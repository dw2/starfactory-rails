# == Schema Information
#
# Table name: comments
#
#  id                    :integer          not null, primary key
#  body                  :text
#  status                :string(255)      default("Published")
#  discussion_id         :integer
#  comment_id            :integer
#  student_profile_id    :integer
#  instructor_profile_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#  admin_profile_id      :integer
#

class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :student_profile
  belongs_to :instructor_profile
  belongs_to :admin_profile

  VALID_STATUSES = %w(Published Locked Removed)
  DEFAULT_SORT_COLUMN = 'comments.created_at'

  delegate :name, to: :discussion, allow_nil: true

  scope :published, -> { where { status.eq 'Published' } }
  scope :locked, -> { where { status.eq 'Locked' } }
  scope :removed, -> { where { status.eq 'Removed' } }
  scope :by_date, -> { order('created_at asc') }

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

  def author_profile_class
    case
    when student_profile.present?
      'student'
    when instructor_profile.present?
      'instructor'
    when admin_profile.present?
      'admin'
    else
      nil
    end
  end

  def is_discussion_author?
    (student_profile.present? && student_profile == discussion.student_profile) ||
    (instructor_profile.present? && instructor_profile == discussion.instructor_profile) ||
    (admin_profile.present? && admin_profile == discussion.admin_profile)
  end

  def css_classes
    classes = [author_profile_class]
    classes.push 'author' if is_discussion_author?
    classes
  end
end
