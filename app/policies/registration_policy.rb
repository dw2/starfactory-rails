class RegistrationPolicy < Struct.new(:user, :registration)
  class Scope < Struct.new(:user, :scope)
    def resolve
      case
      when !user
        scope.none
      when user.admin?
        scope
      when user.student?
        scope
      else
        scope
      end
    end
  end

  def permitted_attributes
    case
    when user.admin?
      [:id, :event_id, :student_profile_id, :status, :amount_paid_in_cents]
    when user.student?
      [:id, :event_id, :student_profile_id]
    else
      []
    end
  end

  def index?
    !!user && (user.admin? || user.student?)
  end

  def show?
    !!user && (user.admin? || user.student?)
  end

  def create?
    !!user
  end

  def new?
    false
  end

  def update?
    !!user && user.admin?
  end

  def edit?
    !!user && user.admin?
  end

  def destroy?
    !!user && (user.admin? || user == registration.student_profile.user)
  end

  # Used by the admin controller
  def registrations?
    !!user && user.admin?
  end
end
