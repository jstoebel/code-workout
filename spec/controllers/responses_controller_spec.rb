require 'spec_helper'

RSpec.describe ResponsesController, :type => :controller do
  include Devise::TestHelpers

  before(:each) do
    FactoryGirl.create :global_role_admin
    FactoryGirl.create :admin, {:email => "admin@test.org"}
    FactoryGirl.create :global_role_instructor
    FactoryGirl.create :instructor_user, {:email => "instructor@test.org"}
    FactoryGirl.create :global_role_user
    FactoryGirl.create :confirmed_user, {:email => "student@test.org"}
    FactoryGirl.create :exercise
    FactoryGirl.create :question
  end
  
  describe "GET show" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r
      let(:my_response){Response.first}
      subject(:get_show) {get :show, :id => my_response.id}

        it "returns http success" do
          get_show
          expect(response).to have_http_status(:success)
        end

        it "pulls the response" do
          get_show
          expect(assigns(:response)).to eq(my_response)
        end

      end
    end
  end


  describe "POST create success" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r

      let(:response_params) {FactoryGirl.attributes_for :response}
      subject(:post_create) {post :create, :response => response_params}

      it "redirects to question page" do
        post_create
        expect(response).to redirect_to(question_path)
      end

      it "saves response" do
      end

      it "pulls parent question" do
      end

      it "pulls sybling responses" do
      end

      end
    end    
  end

end
