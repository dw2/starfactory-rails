module Discussionable
  extend ActiveSupport::Concern

  included do
    has_many :discussions, counter_cache: true
  end
end
