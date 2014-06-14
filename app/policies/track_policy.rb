class TrackPolicy < Struct.new(:user, :track)
  class Scope < Struct.new(:user, :scope)
    def resolve
      case
      when !user
        scope.none
      when user.admin?
        scope
      else
        scope
      end
    end
  end

  def permitted_attributes
    case
    when user.admin?
      [:name, :description, :status]
    else
      []
    end
  end

  def index?
    true
  end

  def show?
    track.status == 'Active' ||
    (!!user && user.admin?)
  end

  def create?
    !!user && user.admin?
  end

  def new?
    !!user && user.admin?
  end

  def update?
    !!user && user.admin?
  end

  def edit?
    !!user && user.admin?
  end

  def destroy?
    false
  end

  # Used by the admin controller
  def tracks?
    !!user && user.admin?
  end
end
