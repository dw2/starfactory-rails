class UserPolicy < Struct.new(:current_user, :user)
  class Scope < Struct.new(:current_user, :scope)
    def resolve
      case
      when !current_user
        none
      when current_user.admin?
        scope
      else
        none
      end
    end
  end

  def permitted_attributes
    case
    when current_user.admin?
      [:id, :name, :bio, :avatar, :user_id, user_attributes: [:id, :email]]
    else
      []
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
