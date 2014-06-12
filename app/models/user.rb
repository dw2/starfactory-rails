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

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :votes

  DEFAULT_SORT_COLUMN = 'users.email'

  include Adminable, Instructorable, Studentable

  def voted_on(resource)
    resource_id = resource.id
    case resource.class.name
    when 'Workshop'
      self.votes.where{ workshop_id.eq resource_id }.any?
    else
      false
    end
  end

  def name
    case
    when admin?
      admin_profile.name
    when instructor?
      instructor_profile.name
    when student?
      student_profile.name
    else
      ''
    end
  end

  def kinds
    kinds = []
    kinds.push 'Admin' if admin?
    kinds.push 'Instructor' if instructor?
    kinds.push 'Student' if student?
    kinds
  end
end
