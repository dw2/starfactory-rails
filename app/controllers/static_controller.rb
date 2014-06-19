class StaticController < ApplicationController
  def index
    @active_events = Event.active.upcoming.limit 3
    @voted_workshops = Workshop.active.voted.limit 3
  end

  def contact
    add_breadcrumb 'Contact'
  end

  def privacy
    add_breadcrumb 'Privacy Policy'
  end

  def terms
    add_breadcrumb 'Terms of Service'
  end

  def conduct
    add_breadcrumb 'Code of Conduct'
  end

  def status403
    add_breadcrumb 'Status 403'
  end

  def status404
    add_breadcrumb 'Status 404'
  end

  def status500
    add_breadcrumb 'Status 500'
  end
end
