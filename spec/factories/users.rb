# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string(255)      not null
#  crypted_password                :string(255)      not null
#  salt                            :string(255)      not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  failed_logins_count             :integer          default(0)
#  lock_expires_at                 :datetime
#  unlock_token                    :string(255)
#  instructor_profile_id           :integer
#  student_profile_id              :integer
#  admin_profile_id                :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'email@starfactory.co'
    password 'Password'

    ignore do
      name 'Some User'
    end
  end
  factory :admin_user, parent: :user do
    after(:build) do |user, evaluator|
      build(:admin_profile, user: user, name: evaluator.name)
    end
  end
  factory :admin_instructor_user, parent: :user do
    after(:build) do |user, evaluator|
      build(:instructor_profile, user: user, name: evaluator.name)
    end
    after(:build) do |user, evaluator|
      build(:instructor_profile, user: user, name: evaluator.name)
    end
  end
  factory :instructor_user, parent: :user do
    after(:build) do |user, evaluator|
      build(:instructor_profile, user: user, name: evaluator.name)
    end
  end
  factory :student_user, parent: :user do
    after(:build) do |user, evaluator|
      build(:student_profile, user: user, name: evaluator.name)
    end
  end
end
