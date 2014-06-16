@instructor_profile = InstructorProfile.first

def add_event(workshop, starts_at, ends_at)
  FactoryGirl.create(:event,
    workshop: workshop,
    starts_at: starts_at,
    ends_at: ends_at,
    cost_in_cents: 15000,
    instructor_profiles: [@instructor_profile],
    registrations_max: 10
  )
end

# Passed Events
Workshop.order('sort asc').limit(2).each_with_index do |workshop, w|
  date = (Time.now + (w - 6).days).strftime('%b %e, %Y 17:00').to_datetime
  add_event(workshop, date, (date + 3.hours))
end

# Future Events
Workshop.order('sort desc').limit(2).each_with_index do |workshop, w|
  date = (Time.now + (w + 6).days).strftime('%b %e, %Y 17:00').to_datetime
  add_event(workshop, date, (date + 3.hours))
end
