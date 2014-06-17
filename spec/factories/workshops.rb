# == Schema Information
#
# Table name: workshops
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :text
#  status            :string(255)      default("Active")
#  banner            :string(255)
#  icon              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  votes_count       :integer          default(0)
#  votes_goal        :integer          default(0)
#  track_id          :integer
#  discussions_count :integer          default(0), not null
#  sort              :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workshop do
    name 'Some Workshop'
    description 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec facilisis in diam ac scelerisque. Praesent eget eleifend lectus. In hac habitasse platea dictumst. Integer malesuada lacus ut facilisis cursus. Quisque sit amet ipsum cursus, sollicitudin libero at, commodo lorem. Proin arcu tellus, adipiscing quis odio ac, adipiscing iaculis quam. Proin eget faucibus purus. Ut lacinia consequat diam nec molestie. Aenean vitae iaculis mauris.'
    status 'Active'
    track_id nil
    events []
    votes_goal 10
  end
end
