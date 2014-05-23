@instructor_profile = InstructorProfile.first

def add_event(workshop, starts_at, ends_at)
  FactoryGirl.create(:event,
    workshop: workshop,
    starts_at: starts_at,
    ends_at: ends_at,
    instructor_profiles: [@instructor_profile]
  )
end

Workshop.all.each_with_index do |workshop, w|
  date = (Time.now + (w + 7).days).strftime('%b %e, %Y 17:00').to_datetime
  add_event(workshop, date, (date + 3.hours))
end
