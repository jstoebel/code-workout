require 'spec_helper'

RSpec.describe QuestionsController, :type => :controller do
  include Devise::TestHelpers

  before(:each) do
    puts "BEFORE ANYTHING"
    puts Exercise.all
    puts Question.all

    # FactoryGirl.create :global_role_admin
    # FactoryGirl.create :admin, {:email => "admin@test.org"}
    # FactoryGirl.create :global_role_instructor
    # FactoryGirl.create :instructor_user, {:email => "instructor@test.org"}
    # FactoryGirl.create :global_role_user
    # FactoryGirl.create :confirmed_user, {:email => "student@test.org"}
    # FactoryGirl.create :exercise
    # FactoryGirl.create :question
  end

  describe "a test" do

    login_as "instructor"
    it "works!" do

    end
  end

  # describe "GET index" do
  #   ControllerMacros::ALL_ROLES.each do |r|
  #     context "as #{r}" do
  #       login_as r
  #       subject(:get_index) { get :index }
  #       it "returns http success" do
  #         get_index
  #         expect(response).to have_http_status(:success)
  #       end

  #       it "pulls all questions" do
  #         get_index
  #         assigns(:questions).should
  #         expect(assigns(:questions)).to eq(Question.all)
  #       end

  #       it "pulls all exercise questions" do
  #         first_ex = Exercise.first
  #         get :index, {:exercise_id => first_ex.id }
  #         expect(assigns(:questions)).to eq(Question.where(exercise_id: first_ex.id))
  #       end

  #       it "renders the index view" do
  #         get_index
  #         expect(response).to render_template("index")
  #       end
  #     end
  #   end
  # end

  # describe "GET show" do
  #   ControllerMacros::ALL_ROLES.each do |r|
  #     context "as #{r}" do
  #       login_as r
  #       it "returns http success" do
  #         get :show, {:id => 1}
  #         expect(response).to have_http_status(:success)
  #       end
        
  #       it "pulls the right question" do
  #         get :show, {:id => 1}
  #         expect(assigns(:question)).to eq(Question.find(1))
  #       end

  #       it "renders the show view" do
  #         get :show, {:id => 1} 
  #         expect(response).to render_template("show")

  #       end
  #     end  
  #   end
  # end

  # describe "GET new" do
  #   ControllerMacros::ALL_ROLES.each do |r|
  #     context "as #{r}" do
  #       login_as r
  #       it "returns http success" do
  #         get :new
  #         expect(response).to have_http_status(:success)
  #       end

  #       it "instantiates a new record" do
  #         get :new
  #         expect(assigns(:question)).to be_a_new(Question)
  #       end

  #       it "renders the new view" do
  #         get :new
  #         expect(response).to render_template("new")
  #       end
  #     end
  #   end
  # end

  # describe "POST create success" do
  #   ControllerMacros::ALL_ROLES.each do |r|

  #     subject(:post_question) {post :create,
  #       :question => 
  #         FactoryGirl.build(:question, :exercise => Exercise.first).attributes
  #     }
  #     context "as #{r}" do
  #       login_as r

  #       it "redirects to index" do
  #         post_question
  #         expect(response).to redirect_to(questions_path)
  #       end

  #       it "creates a new record" do
  #         expect { post_question 
  #           }.to change{ Question.count }.by(1)
  #       end

  #       it "creates question for user" do
  #         post_question
  #         expect(assigns(:question).user_id).to eq(@test_user.id) # user id from session hash
  #       end

  #       it "displays a flash message" do
  #         post_question
  #         expect(flash[:success]).to eq("Question saved!")

  #       end

  #     end
  #   end
  # end

  # describe "POST create fail bad params" do
  #   ControllerMacros::ALL_ROLES.each do |r|


  #     q_attrs = FactoryGirl.build(:question, :exercise => Exercise.first).attributes
  #     q_attrs["title"] = nil
  #     subject(:post_question) {post :create,
  #       :question => 
  #         q_attrs
  #     }
  #     context "as #{r}" do
  #       login_as r

  #       it "renders new" do
  #         post_question
  #         expect(response).to render_template("new")
  #       end

  #       it "displays a flash message" do
  #         post_question
  #         expect(flash[:error]).to eq("Error creating your question.")
  #       end
  #     end
  #   end
  # end

  # describe "POST destroy success" do
  #   #should be able to destroy when the post belongs to you
  #   #or if you are an admin
  #   ControllerMacros::ALL_ROLES.each do |r|
  #     context "as #{r}" do
  #       login_as r
  #       my_question = FactoryGirl.create(:question)
  #       subject(:post_destroy) {post :destroy, {:id => my_question.id}}
  #       it "redirects to index" do
  #         post_destroy
  #         expect(response).to redirect_to(questions_path)
  #       end

  #       it "destroys a record" do
  #       end

  #       it "displays a flash message" do
  #       end
  #     end
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
