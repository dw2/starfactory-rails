module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, counter_cache: true
  end
end
