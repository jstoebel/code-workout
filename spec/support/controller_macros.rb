module ControllerMacros

  ALL_ROLES = ["administrator", "instructor", "regular_user"]
  def login_as(role_name)
    before(:each) do
      @test_user = User.find_by(:global_role_id => (GlobalRole.send(role_name)).id)
      # puts "MACRO HERE IS THE USER ID #{@test_user.id}"
      # puts "gonna sign us this user #{@test_user.inspect}"
      sign_in @test_user
    end
  end

  def login_admin
    # @request.env["devise.mapping"] = Devise.mappings[:admin]

    admin = User.find_by(:global_role_id => (GlobalRole.administrator).id)
    sign_in admin
  end
end