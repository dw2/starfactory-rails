class CommentPolicy < Struct.new(:user, :comment)
  class Scope < Struct.new(:user, :scope)
    def resolve
      case
      when !user
        none
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
    false
  end

  def show?
    false
  end

  def create?
    !!user
  end

  def new?
    false
  end

  def update?
    edit?
  end

  def edit?
    !!user && (
      user.admin? ||
      (comment.student_profile.present? && user.student_profile == comment.student_profile) ||
      (comment.instructor_profile.present? && user.instructor_profile == comment.instructor_profile)
    )
  end

  def destroy?
    edit?
  end

  # Used by the admin controller
  def comments?
    !!user && user.admin?
  end
end
