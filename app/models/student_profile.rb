# == Schema Information
#
# Table name: student_profiles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  bio        :text
#  avatar     :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class StudentProfile < ActiveRecord::Base
  belongs_to :user, inverse_of: :student_profile
  has_many :registrations
  has_many :events, -> { uniq }, through: :registrations
  has_many :workshops, -> { uniq }, through: :events
  has_many :tracks, -> { uniq }, through: :workshops

  DEFAULT_SORT_COLUMN = 'student_profiles.name'

  scope :by_name, -> { order('student_profiles.name asc') }

  delegate :email, to: :user, allow_nil: true

  validates_presence_of :name
  validates_presence_of :user
end
