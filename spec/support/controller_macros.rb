module ControllerMacros

  ALL_ROLES = ["administrator", "instructor", "regular_user"]
  def login_as(role_name)
    before(:each) do

      user = User.find_by(:global_role_id => (GlobalRole.send(role_name)).id)
      sign_in user
    end
  end
end