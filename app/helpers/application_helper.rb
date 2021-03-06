module ApplicationHelper

  def body_classes
    classes = [
      under_camel(params[:controller]),
      under_camel(params[:action]),
      under_camel("#{params[:controller]}_#{params[:action]}")
    ]
    classes.push 'hasQueryString' unless request.query_string.blank?
    if (classes & [
        'staticIndex', 'workshopsShow', 'eventsShow', 'tracksShow',
        'instructorProfilesShow', 'studentProfilesShow'
      ]).count > 0
      classes.push 'withSidebar'
    end
    classes.push 'loggedIn' if logged_in?
    return classes
  end

  def under_camel(string)
    string.gsub(/[^a-z]/i,'_').camelize(:lower)
  end

  def text_to_html(text)
    return sanitize Kramdown::Document.new(text).to_html
  end

  def format_markdown(text)
    sanitize Kramdown::Document.new(text).to_html
  end

  def twitter_url
    'https://twitter.com/starfactory'
  end

  def facebook_url
    'https://www.facebook.com/starfactory.co'
  end

  def svg_image(src, options={})
    options[:onerror] = "this.src='#{image_url src+'.png'}';this.onerror=null;"
    image_tag "#{src}.svg", options
  end

  def cents_to_formatted_dollars(cents)
    dollars = cents / 100
    if cents <= 0
      'Free'
    elsif dollars.to_i != dollars
      ActionController::Base.helpers.number_to_currency(
        dollars, precision: 2, locale: :en)
    else
      "$#{dollars.to_i}"
    end
  end

  def sort_link(text, column, resource=nil, anchor=nil)
    # Is this the default column?
    if !resource
      if controller_name == 'admin'
        resource = action_name.classify.constantize 
      else
        resource = controller_name.classify.constantize
      end
    end
    default_column = defined?(resource::DEFAULT_SORT_COLUMN) ? resource::DEFAULT_SORT_COLUMN : 'name'
    if !params[:sort] && (column == default_column || column == 'id')
      direction = 'desc'
      active = 'active'
    # Which way are we sorting?
    else
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      active = params[:sort] == column ? 'active' : ''
    end
    # Build the link
    q = Rack::Utils.parse_nested_query(request.query_string)
    q['sort'] = column
    q['direction'] = direction
    link_to text, "?#{q.to_query}#{anchor ? '#' + anchor : ''}", class: "#{direction} #{active}"
  end
end
