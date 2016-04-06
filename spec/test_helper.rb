module LoginHelper
  require 'spec_helper'
  include Devise::TestHelpers

  ALL_USERS = ["administrator", "instructor", "regular_user"]

  def self.login_as(user_type)
    # user = User.where(:login => user.to_s).first if user.is_a?(Symbol)
    # request.session[:user] = user.id
    #user_type: string repsenting type of user to login. Can be, :admiistrator, :instructor, or :regular_user
    user = User.find_by(global_role_id: GlobalRole.send(user_type))
    # request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end