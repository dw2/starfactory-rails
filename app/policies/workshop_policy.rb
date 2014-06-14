class WorkshopPolicy < Struct.new(:user, :workshop)
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
      [:name, :description, :status, :banner, :icon,
        :track_ids => [], :instructor_profile_ids => []]
    else
      []
    end
  end

  def index?
    true
  end

  def show?
    workshop.status == 'Active' ||
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
  def workshops?
    !!user && user.admin?
  end
end
