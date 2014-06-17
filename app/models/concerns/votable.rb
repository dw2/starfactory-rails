module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy
  end

  def votes_to_go
    votes_goal - votes_count
  end
end
