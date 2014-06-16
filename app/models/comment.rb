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
  counter_culture :discussion
  belongs_to :student_profile
  belongs_to :instructor_profile
  belongs_to :admin_profile

  VALID_STATUSES = %w(Published Locked Removed)
  DEFAULT_SORT_COLUMN = 'comments.created_at'
  DEFAULT_SORT_DIRECTION = 'desc'
  PER_PAGE = 10

  paginates_per PER_PAGE

  delegate :name, to: :discussion, allow_nil: true

  scope :published, -> { where { status.eq 'Published' } }
  scope :locked, -> { where { status.eq 'Locked' } }
  scope :removed, -> { where { status.eq 'Removed' } }
  scope :by_date, -> { order('created_at asc') }

  def snippet
    ActionController::Base.helpers.truncate(
      ActionController::Base.helpers.strip_tags(body_html),
      length: 50, separator: ' ')
  end

  def author
    case
    when student_profile.present?
      student_profile
    when instructor_profile.present?
      instructor_profile
    when admin_profile.present?
      admin_profile
    else
      nil
    end
  end

  def author_user
    author.user
  end

  def author_name
    author.name
  end

  def author_url
    url_helpers = Rails.application.routes.url_helpers
    case
    when student_profile.present?
      url_helpers.student_profile_url student_profile, host: app.root_url
    when instructor_profile.present?
      url_helpers.instructor_profile_url instructor_profile, host: app.root_url
    else
      nil
    end
  end

  def author_avatar_html
    ApplicationController.new.render_to_string(partial: 'shared/avatar', locals: {
      email: author_user.email, size: 100 })
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

  def body_html
    ApplicationController.helpers.format_markdown body
  end

  def created_at_formatted
    created_at.strftime '%b %e, %Y @ %l:%M %P'
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
