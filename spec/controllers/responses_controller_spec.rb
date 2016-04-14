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
  
  let (:my_response) { FactoryGirl.create(:response, 
    {:user_id => @test_user.id,
     :question_id => Question.first.id
    })
  }

  let (:admin_response) { FactoryGirl.create(:response, 
    {:user_id => 1,
     :question_id => Question.first.id
    })
  }

  describe "GET SHOW" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r
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


  describe "POST CREATE success" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r

      let(:response_params) {FactoryGirl.attributes_for :response, {:question_id => Question.first.id, :user_id => @test_user.id} }
      subject(:post_create) {post :create, :response => response_params}


        it "saves response" do
          post_create
          compare_attrs = response_params.map { |k, v| v == assigns(:response).send(k) }
          expect(compare_attrs.all?).to be true
        end

        it "pulls parent question" do
          post_create

          expect(assigns(:question)).to eq(Question.find(response_params[:question_id]))
        end

        it "pulls sibling responses" do
          post_create
          expect(assigns(:responses)).to eq(Question.find(response_params[:question_id]).responses)
        end

        it "displays flash message" do
          post_create
          expect(flash[:success]).to eq("Response saved!")
        end

        it "redirects to question page" do
          post_create
          expect(response).to redirect_to(question_path(response_params[:question_id]))
        end

      end
    end    
  end

  describe "POST CREATE fail bad params" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r

      let(:response_params) {FactoryGirl.attributes_for :response, {:question_id => Question.first.id, :user_id => @test_user.id}}
      subject(:post_create) {post :create, :response => response_params.except(:text)}


      it "does not save response" do
        expect { post_create }.to_not change{ Response.count }
      end

      it "displays flash message" do
        post_create
        expect(flash[:error]).to eq("Error creating your response.")
      end

      it "renders question show" do
        expect(post_create).to render_template("questions/show")
      end

      end
    end
  end

  describe "GET EDIT" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r
        
        subject(:get_edit) { get :edit, {:id => my_response.id} }

        it "returns http success" do
          get_edit
          expect(response).to have_http_status(:success)
        end

        it "pulls the right record" do
          get_edit
          expect(assigns(:response)).to eq(my_response)

        end

        it "renders the edit view" do
          get_edit
          expect(response).to render_template('edit')
        end

      end
    end   
  end

  describe "GET EDIT fail no access" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
      login_as r

        subject(:get_edit) { get :edit, {:id => admin_response.id} }

        it "redirects to root_path" do
          get_edit
          expect(response).to redirect_to(root_path)
        end

      end
    end   
  end

  describe "POST UPDATE success" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
      login_as r

        let(:change) { {:text => "new title"} }
        let(:update_params) { {:id => my_response.id,
          :response => my_response.attributes.merge(change)}
        }
        subject(:post_update) { post :update, update_params}

        it "updates the response" do
          post_update
          compare_attrs = change.map { |k, v| v == assigns(:response).send(k) }
          expect(compare_attrs.all?).to be true    
        end

        it "displays a flash message" do
          post_update
          expect(flash[:success]).to eq("Response edit saved!")
        end

        it "redirects to question page" do
          post_update
          expect(response).to redirect_to(question_path(my_response.question.id))
        end

      end
    end
  end

  describe "POST UPDATE fail no access" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
      login_as r

        let(:change) { {:text => "new title"} }
        let(:update_params) { {:id => admin_response.id,
          :response => admin_response.attributes.merge(change)}
        }
        subject(:post_update) { post :update, update_params}

        it "redirects to root path" do
          post_update
          expect(response).to redirect_to(root_path)
        end

        it "does not update the record" do
          post_update
          compare_attrs = change.map { |k, v| v == assigns(:response).send(k) }
          expect(compare_attrs.all?).to be false
        end
      end
    end
  end

  # NOT TESTING FOR DELETE SINCE IT IS NOT CURRENTLY IN USE 
  # (NOT IN THE ROUTES FILE)

  describe "POST destroy success" do
    #should be able to destroy when the post belongs to you
    #or if you are an admin
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
        login_as r
        subject(:post_destroy) { post :destroy, {:id => my_response.id} }

        it "redirects to question page" do
          post_destroy
          expect(response).to redirect_to(question_path(my_response.question.id))
        end

        it "destroys a record" do
          post_destroy
          expect(Response.all).not_to include my_response
        end

        it "displays a flash message" do
          post_destroy
          expect(flash[:success]).to eq("You have successfully deleted the response")
        end
      end
    end
  end

end
