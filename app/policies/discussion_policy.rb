class DiscussionPolicy < Struct.new(:user, :discussion)
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
    when !!user
      [:id, :name, :workshop_id, :status,
        :student_profile_id, :instructor_profile_id]
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
    new?
  end

  def new?
    !!user
  end

  def update?
    edit?
  end

  def edit?
    !!user && (
      user.admin? ||
      (discussion.student_profile.present? && user.student_profile == discussion.student_profile) ||
      (discussion.instructor_profile.present? && user.instructor_profile == discussion.instructor_profile)
    )
  end

  def destroy?
    edit?
  end

  # Used by the admin controller
  def discussions?
    !!user && user.admin?
  end
end
