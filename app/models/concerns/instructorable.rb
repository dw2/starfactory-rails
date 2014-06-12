module Instructorable
  extend ActiveSupport::Concern

  included do
    has_one :instructor_profile, inverse_of: :user
    accepts_nested_attributes_for :instructor_profile

    delegate :id, to: :instructor_profile, prefix: true, allow_nil: true
  end

  def instructor?
    !instructor_profile.nil?
  end
end
