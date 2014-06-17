class CommentPolicy < Struct.new(:user, :comment)
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
      [:id, :body, :discussion_id, :student_profile_id]
    when !!user && user.instructor?
      [:id, :body, :discussion_id, :instructor_profile_id]
    when !!user && user.admin?
      [:id, :body, :discussion_id,
        :student_profile_id, :instructor_profile_id, :admin_profile_id]
    else
      []
    end
  end

  def index?
    !!user
  end

  def show?
    !!user
  end

  def create?
    !!user
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
  def comments?
    !!user && user.admin?
  end
end
