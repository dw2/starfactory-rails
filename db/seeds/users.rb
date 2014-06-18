admin = FactoryGirl.create(:admin_user,
  name: 'Doug Waltman', email: 'doug@dougwaltman.com')
admin.activate!

(1..2).each { |n|
  user = FactoryGirl.create(:instructor_user,
    name: "Instructor #{n}", email: "instructor#{n}@starfactory.co")
  user.activate!
}

(1..5).each { |n|
  user = FactoryGirl.create(:student_user,
    name: "Student #{n}", email: "student#{n}@starfactory.co")
  user.activate!
}
