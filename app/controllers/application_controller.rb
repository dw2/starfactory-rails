class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  add_flash_types :error, :notice
  before_filter :add_breadcrumbs
  before_filter :set_mailer_host

private
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    error = I18n.t "pundit.#{policy_name}.#{exception.query}", default: ''
    flash[:error] = error unless error.blank?
    render 'static/status403'
  end

  def add_breadcrumbs
    add_breadcrumb 'Starfactory', :root_url
    if logged_in? && current_user.admin? &&
      ['new', 'create', 'edit', 'update', 'destroy'].include?(params[:action])
      add_breadcrumb 'Admin', :admin_url
    end
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def model_class
    case
    when controller_name == 'admin'
      model_class = action_name.classify.constantize
    else
      model_class = controller_name.classify.constantize
    end
  end

  def sort_column
    case
    when !!params[:sort]
      sort_string = params[:sort].gsub(/[^a-z_\.]/i, '')
    when defined?(model_class::DEFAULT_SORT_COLUMN)
      sort_string = model_class::DEFAULT_SORT_COLUMN
    when model_class.column_names.include?('name')
      sort_string = 'name'
    else
      sort_string = 'id'
    end
    # Try and detect if the sort is not a string (int, date, etc.)
    if sort_string.match(/_at|number|count|sort|amount|id$/i)
      sort_string
    else
      "LOWER(#{sort_string})"
    end
  end

  def sort_direction
    case
    when %w[asc desc].include?(params[:direction])
      params[:direction]
    when defined?(model_class::DEFAULT_SORT_DIRECTION)
      model_class::DEFAULT_SORT_DIRECTION
    else
      'asc'
    end
  end
end
