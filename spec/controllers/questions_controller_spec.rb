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

        let(:my_question){ Question.first }
        subject(:get_show){
          get :show, {:id => my_question.id}
        }
        it "returns http success" do
          get_show
          expect(response).to have_http_status(:success)
        end
        
        it "pulls the right question" do
          get_show
          expect(assigns(:question)).to eq(Question.find(my_question.id))
        end

        it "renders the show view" do
          get_show
          expect(response).to render_template("show")
        end

        it "pulls all related responses" do
          get_show
          expect(assigns(:responses)).to eq(my_question.responses)
        end

        it "makes a new response" do
          get_show
          expect(assigns(:response)).to be_a_new(Response)
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
    (ControllerMacros::ALL_ROLES).each do |r|
      context "as #{r}" do
        login_as r

        let(:my_question) { FactoryGirl.create(:question, :user_id => @test_user.id) }

        let(:change) { {:title => "new title"} }
        let(:update_params) { {:id => my_question.id, 
            :question => my_question.attributes.merge(change)}
          }

        subject(:post_update) { post :update, update_params }

        it "redirects to index" do
          post_update
          expect(response).to redirect_to(question_path(my_question.id))
        end

        it "updates the record" do
          post_update
          compare_attrs = change.map { |k, v| v == assigns(:question).send(k) }
          expect(compare_attrs.all?).to be true
          # expect(assigns(:question)).to eq(update_params[:question])
        end

        it "displays flash message" do
          post_update
          expect(flash[:success]).to eq("Question saved!")
        end
      end
    end
  end

  describe "POST update fail no access" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
        login_as r

        let(:new_student) { FactoryGirl.create :confirmed_user, 
          {:email => "new_student@test.org"} 
        }

        let(:not_my_question) { FactoryGirl.create(:question, 
          :user_id => new_student.id) 
        }
        
        let(:change) { {:title => "new title"} }
        let(:update_params) { {:id => not_my_question.id, 
            :question => not_my_question.attributes.merge(change)}
          }

        subject(:post_update) { post :update, update_params }

        it "redirects to root path" do
          post_update
          expect(response).to redirect_to(root_path)
        end

        it "does not update the record" do
          post_update
          compare_attrs = change.map { |k, v| v == assigns(:question).send(k) }
          expect(compare_attrs.all?).to be false
        end

      end
    end
  end

  describe "POST update fail bad param" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
        login_as r

        let(:last_question) { FactoryGirl.create(:question, :user_id => 1) }
        
        let(:update_params) { {:id => last_question.id + 1, 
            :question => last_question.attributes}
          }

        subject(:post_update) { post :update, update_params }

        it "raises ActiveRecord::RecordNotFound" do
          expect { post_update }.to raise_error(ActiveRecord::RecordNotFound)
        end

      end
    end
  end

  describe "GET search" do
    (ControllerMacros::ALL_ROLES - ["administrator"]).each do |r|
      context "as #{r}" do
        login_as r

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        
      end
    end
  end

end
