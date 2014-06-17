class DiscussionPolicy < Struct.new(:user, :discussion)
  class Scope < Struct.new(:user, :scope)
    def resolve
      case
      when !user
        scope.none
      else
        scope
      end
    end
  end

  def permitted_attributes
    case
    when !!user && user.student?
      [:id, :name, :body, :workshop_id, :status, :student_profile_id]
    when !!user && user.instructor?
      [:id, :name, :body, :workshop_id, :status, :instructor_profile_id]
    when !!user && user.admin?
      [:id, :name, :body, :workshop_id, :status,
        :student_profile_id, :instructor_profile_id, :admin_profile_id]
    else
      []
    end
  end

  def index?
    !!user
  end

  def forum?
    index?
  end

  def show?
    !!user
  end

  def create?
    new?
  end

  def new?
    !!user
  end

  def update?
    !!user && user.admin?
  end

  def edit?
    !!user && user.admin?
  end

  def destroy?
    !!user && user.admin?
  end

  # Used by the admin controller
  def discussions?
    !!user && user.admin?
  end
end
