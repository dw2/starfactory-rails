class StudentProfilePolicy < Struct.new(:user, :student_profile)
  class Scope < Struct.new(:user, :scope)
    def resolve
      case
      when !user
        scope.none
      when !!user && user.admin?
        scope
      else
        scope
      end
    end
  end

  def permitted_attributes
    case
    when !!user && user.admin?
      [:name, :bio, :avatar, :user_id]
    when !!user && user.student?
      [:name, :bio, :avatar]
    else
      []
    end
  end

  def index?
    !!user && user.admin?
  end

  def show?
    !!user
  end

  def create?
    !!user && user.admin?
  end

  def new?
    !!user && user.admin?
  end

  def update?
    !!user && (user.admin? || user == student_profile.user)
  end

  def edit?
    !!user && (user.admin? || user == student_profile.user)
  end

  def destroy?
    false
  end

  # Used by the admin controller
  def student_profiles?
    !!user && user.admin?
  end
end
