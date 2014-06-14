# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  status      :string(255)      default("Active")
#  created_at  :datetime
#  updated_at  :datetime
#

class Track < ActiveRecord::Base
  has_many :workshops
  has_many :discussions, through: :workshops

  VALID_STATUSES = %w(Active Disabled)
  DEFAULT_SORT_COLUMN = 'name'

  scope :active, -> { where { status.eq 'Active' } }
  scope :by_name, -> { order('name asc') }

  def last_comment
    Comment
      .where(discussion_id: discussions.pluck(:id))
      .by_date.last
  end
end
