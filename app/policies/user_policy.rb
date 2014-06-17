class UserPolicy < Struct.new(:current_user, :user)
  class Scope < Struct.new(:current_user, :scope)
    def resolve
      case
      when !current_user
        scope.none
      when current_user.admin?
        scope
      else
        scope
      end
    end
  end

  def permitted_attributes
    case
    when current_user.admin?
      [:id, :email,
        instructor_profile_attributes: [:id, :user_id, :name, :bio],
        student_profile_attributes: [:id, :user_id, :name, :bio]]
    when current_user.instructor?
      [:id, :email,
        instructor_profile_attributes: [:id, :user_id, :name, :bio]]
    else
      [:id, :email,
        student_profile_attributes: [:id, :user_id, :name, :bio]]
    end
  end

  def index?
    !!current_user && current_user.admin?
  end

  def show?
    !!current_user && (current_user.admin? || current_user == user)
  end

  def create?
    !!current_user && current_user.admin?
  end

  def new?
    !!current_user && current_user.admin?
  end

  def update?
    !!current_user && current_user.admin?
  end

  def edit?
    !!current_user && current_user.admin?
  end

  def destroy?
    false
  end

  # Used by the admin controller
  def users?
    !!current_user && current_user.admin?
  end
end
