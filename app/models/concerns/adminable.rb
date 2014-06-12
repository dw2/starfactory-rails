module Adminable
  extend ActiveSupport::Concern

  included do
    has_one :admin_profile, inverse_of: :user
    accepts_nested_attributes_for :admin_profile

    delegate :id, to: :admin_profile, prefix: true, allow_nil: true
  end

  def admin?
    !admin_profile.nil?
  end
end
