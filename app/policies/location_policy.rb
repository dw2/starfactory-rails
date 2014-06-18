class LocationPolicy < Struct.new(:user, :location)
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def permitted_attributes
    case
    when !!user && user.admin?
      [:name, :address]
    else
      []
    end
  end

  def index?
    !!user && user.admin?
  end

  def show?
    true
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
    !!user && user.admin? && location.events_count == 0
  end

  # Used by the admin controller
  def locations?
    !!user && user.admin?
  end
end
