class CouponPolicy < Struct.new(:user, :coupon)
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def permitted_attributes
    case
    when !!user && user.admin?
      [:code, :description, :amount_in_cents, :amount_in_dollars, :expires_at, :event_id]
    else
      [:code, :event_id]
    end
  end

  def index?
    !!user && user.admin?
  end

  def show?
    !!user && user.admin?
  end

  def check?
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
    !!user && user.admin?
  end

  # Used by the admin controller
  def coupons?
    !!user && user.admin?
  end
end
