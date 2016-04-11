require 'spec_helper'

RSpec.describe QuestionsController, :type => :controller do
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

  # describe "a test" do

  #   login_as "instructor"
  #   it "works!" do

  #   end
  # end

  describe "GET index" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
        login_as r
        subject(:get_index) { get :index }
        it "returns http success" do
          get_index
          expect(response).to have_http_status(:success)
        end

        it "pulls all questions" do
          get_index
          expect(assigns(:questions)).to eq(Question.all)
        end

        it "pulls all exercise questions" do
          first_ex = Exercise.first
          get :index, {:exercise_id => first_ex.id }
          expect(assigns(:questions)).to eq(Question.where(exercise_id: first_ex.id))
        end

        it "renders the index view" do
          get_index
          expect(response).to render_template("index")
        end
      end
    end
  end

  describe "GET show" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
        login_as r

        subject(:get_show){
          question = Question.first
          get :show, {:id => question.id}
        }
        it "returns http success" do
          get_show
          expect(response).to have_http_status(:success)
        end
        
        it "pulls the right question" do
          get_show
          expect(assigns(:question)).to eq(Question.find(Question.first.id))
        end

        it "renders the show view" do
          get_show
          expect(response).to render_template("show")

        end
      end  
    end
  end

  describe "GET new" do
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
        login_as r
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "instantiates a new record" do
          get :new
          expect(assigns(:question)).to be_a_new(Question)
        end

        it "renders the new view" do
          get :new
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "POST create success" do
    ControllerMacros::ALL_ROLES.each do |r|

      subject(:post_question) {post :create,
        :question => 
          FactoryGirl.build(:question, :exercise => Exercise.first).attributes
      }
      context "as #{r}" do
        login_as r

        it "redirects to index" do
          post_question
          expect(response).to redirect_to(questions_path)
        end

        it "creates a new record" do
          expect { post_question 
            }.to change{ Question.count }.by(1)
        end

        it "creates question for user" do
          post_question
          expect(assigns(:question).user_id).to eq(@test_user.id) # user id from session hash
        end

        it "displays a flash message" do
          post_question
          expect(flash[:success]).to eq("Question saved!")

        end

      end
    end
  end

  describe "POST create fail bad params" do
    ControllerMacros::ALL_ROLES.each do |r|


      q_attrs = FactoryGirl.build(:question, :exercise => Exercise.first).attributes
      q_attrs["title"] = nil
      subject(:post_question) {post :create,
        :question => 
          q_attrs
      }
      context "as #{r}" do
        login_as r

        it "renders new" do
          post_question
          expect(response).to render_template("new")
        end

        it "displays a flash message" do
          post_question
          expect(flash[:error]).to eq("Error creating your question.")
        end
      end
    end
  end

  describe "POST destroy success" do
    #should be able to destroy when the post belongs to you
    #or if you are an admin
    ControllerMacros::ALL_ROLES.each do |r|
      context "as #{r}" do
        login_as r
        let (:my_question) { FactoryGirl.create(:question, :user_id => @test_user.id) }
        subject(:post_destroy) { post :destroy, {:id => my_question.id} }

        it "redirects to index" do
          post_destroy
          expect(response).to redirect_to(questions_path)
        end

        it "destroys a record" do
          post_destroy
          expect(Question.all).not_to include my_question
        end

        it "displays a flash message" do
          post_destroy
          expect(flash[:success]).to eq("You have successfully deleted the question")
        end
      end
    end
  end

  describe "POST destroy fail no access" do
    (ControllerMacros::ALL_ROLES - ['administrator']).each do |r|
      context "as #{r}" do
        login_as r
        let (:admin_question) { FactoryGirl.create(:question, :user_id => 1) }
        subject(:post_destroy) { post :destroy, {:id => admin_question.id} }
        
        it "redirects to root" do
          post_destroy
          expect(response).to redirect_to(root_path)
        end

        it "doesn't destroy record" do
          post_destroy
          expect(Question.all).to include admin_question
        end
      end
    end
  end

  describe "POST destroy fail bad id" do
    (ControllerMacros::ALL_ROLES).each do |r|
      context "as #{r}" do
        login_as r
        let (:last_question) { Question.last }
        subject(:post_destroy) { post :destroy, {:id => Question.last.id + 1} }
        
        it "raises ActiveRecord::RecordNotFound" do
          expect { post_destroy }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "GET edit" do
    (ControllerMacros::ALL_ROLES).each do |r|
      context "as #{r}" do
        login_as r

        let (:my_question) { FactoryGirl.create(:question, :user_id => @test_user.id) }
        subject(:get_edit) { get :edit, {:id => my_question.id} }

        it "returns http success" do
          get_edit
          expect(response).to have_http_status(:success)
        end

        it "pulls the right record" do
          get_edit
          expect(assigns(:question)).to eq(my_question)

        end

        it "renders the edit view" do
          get_edit
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe "GET edit fail no access" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
        login_as r

        let (:admin_question) { FactoryGirl.create(:question, :user_id => 1) }
        subject(:get_edit) { get :edit, {:id => admin_question.id} }

        it "redirects to root" do
          get_edit
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "GET edit fail bad id" do
    (ControllerMacros::ALL_ROLES).each do |r|
      context "as #{r}" do
        login_as r

        let (:last_question) { Question.last }
        subject(:get_edit) { get :edit, {:id => last_question.id + 1} }

        it "raises ActiveRecord::RecordNotFound" do
          expect { get_edit }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "POST update success" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
        login_as r

        let(:my_question) { FactoryGirl.create(:question, :user_id => @test_user.id) }
        let(:update_params) { {:id => my_question.id, :question => {
              :title => "new title",
              :body => my_question.body,
              :tags => my_question.tags,
              :exercise_id => my_question.exercise_id
            }
          }
        }


        subject(:post_update) { post :update, update_params }

        it "redirects to index" do
          post_update
          expect(response).to redirect_to(questions_path)
        end

        it "updates the record" do
          post_update
          #check that params match

        end

        it "displays flash message" do
        end
  end

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
