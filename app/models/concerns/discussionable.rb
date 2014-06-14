module Discussionable
  extend ActiveSupport::Concern

  included do
    has_many :discussions
  end
end
