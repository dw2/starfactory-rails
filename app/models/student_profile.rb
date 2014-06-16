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
  has_many :events, through: :registrations, uniq: true
  has_many :workshops, through: :events, uniq: true
  has_many :tracks, through: :workshops, uniq: true

  DEFAULT_SORT_COLUMN = 'student_profiles.name'

  accepts_nested_attributes_for :user

  scope :by_name, -> { order('name asc') }

  validates :name, presence: true
  validates :user, presence: true

  delegate :email, to: :user, allow_nil: true
end
