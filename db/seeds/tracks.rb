def add_workshop(track, name, sort)
  FactoryGirl.create(:workshop,
    name: name,
    track_id: track.id,
    sort: sort
  )
end

track_general = FactoryGirl.create :track, name: 'General', sort: 1
add_workshop track_general, 'Beginning HTML', 1
add_workshop track_general, 'Intro to Programming', 2
add_workshop track_general, 'Using Git & Github', 3

track_css = FactoryGirl.create :track, name: 'CSS', sort: 2
add_workshop track_css, 'Beginning CSS', 1
add_workshop track_css, 'Advanced CSS Concepts 1', 2
add_workshop track_css, 'Advanced CSS Concepts 2', 3

track_js = FactoryGirl.create :track, name: 'JavaScript', sort: 3
add_workshop track_js, 'Intro to JavaScript', 1
add_workshop track_js, 'JS: DOM Manipulation', 2
add_workshop track_js, 'JS: Functions', 3
add_workshop track_js, 'JS: Events', 4
add_workshop track_js, 'JS: Advanced Concepts', 5
add_workshop track_js, 'JS: Frameworks', 6
add_workshop track_js, 'Intro to CoffeeScript', 7

track_wp = FactoryGirl.create :track, name: 'WordPress', sort: 4
add_workshop track_wp, 'Intro to WordPress', 1
add_workshop track_wp, 'PHP for WordPress', 2
add_workshop track_wp, 'Your First WordPress Theme', 3
add_workshop track_wp, 'Your First WordPress Plugin', 4

track_ror = FactoryGirl.create :track, name: 'Ruby on Rails', sort: 5
add_workshop track_ror, 'Intro to Ruby', 1
add_workshop track_ror, 'Intro to Rails', 2
add_workshop track_ror, 'Your First Rails App', 3
