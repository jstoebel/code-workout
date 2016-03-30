require 'spec_helper'

RSpec.describe QuestionsController, :type => :controller do
  include Devise::TestHelpers

  before(:each) do
    FactoryGirl.create :global_role_admin
    FactoryGirl.create :global_role_instructor
    FactoryGirl.create :global_role_user
    user = FactoryGirl.create :confirmed_user
    FactoryGirl.create :exercise
    FactoryGirl.create :question
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "a test" do
    it "works!" do
      
    end
  end

  let(:valid_attributes) { { 
    title: "question title",
    body: "question body"
   } }

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "pulls all questions" do
      get :index
      assigns(:questions).should
      expect(assigns(:teams)).to eq(Question.all)
    end

    it "renders the index view" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "returns http success" do
      get :show, {:id => 1}
      expect(response).to have_http_status(:success)
    end
    
    it "pulls the right question" do
      get :show
    end

  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "makes a new record" do
      assigns(:question).should be_a_new(Question)
    end

    it "renders the new view" do
    end
  end

  describe "POST create success" do
    it "redirects to index" do

      question_params = FactoryGirl.attributes_for(:question)
      expect {post(
          :create, 
          {:question => question_params},
          {:user_id => User.first.id}
        ) 
      }.to change(Question, :count).by(1)
      expect(response).to redirect_to(questions_path) #FIX THIS! SHOULD REDIRECT!
    end

    it "creates a new record" do
    end

    it "displays a flash message" do
    end
  end

  # describe "POST create fail" do
    
  #   it "returns http success" do
  #   end

  #   it "renders new form" do
  #   end

  #   it "displays a flash message" do
  #   end

  # end

  # describe "GET edit" do
  #   it "returns http success" do
  #     get :edit
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "pulls the right record" do
  #   end

  #   it "renders the edit view" do
  #   end
  # end

  # describe "POST update success" do
  #   it "redirects to index" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "updates the record" do
  #   end

  #   it "displays flash message" do
  #   end
  # end

  # describe "POST update fail" do
  #   it "returns http success" do
  #   end

  #   it "renders edit view" do
  #   end

  #   it "displays flash message" do
  #   end
  # end

  # describe "GET delete" do
  #   it "returns http success" do
  #     get :delete
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "pulls the right record" do
  #   end

  #   it "renders the delete view" do
  #   end

  # end

  # describe "POST destroy success" do
  #   it "redirects to index" do
  #     get :destroy
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "destroys a record" do
  #   end

  #   it "displays a flash message" do
  #   end

  # end

  # describe "POST destroy fail" do
  #   it "returns http success" do
  #   end

  #   it "renders the index view" do
  #   end

  #   it "displays a flash message" do
  #   end
  # end
end
