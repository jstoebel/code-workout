module ControllerMacros
  # def login_admin
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:admin]
  #     sign_in FactoryGirl.create(:admin) # Using factory girl as an example
  #   end
  # end

  def setup_users
    FactoryGirl.create :global_role_admin
    FactoryGirl.create :global_role_instructor
    FactoryGirl.create :global_role_user

    @administrator = FactoryGirl.create(:admin,
      email:  "admin@test.org")
    @instructor = FactoryGirl.create(:instructor_user,
      email:  "inst_user@test.org")
    @regular_user = FactoryGirl.create(:confirmed_user,
      email:  "reg_user@test.org")
  end
end