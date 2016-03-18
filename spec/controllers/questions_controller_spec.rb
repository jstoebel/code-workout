require 'spec_helper'

RSpec.describe QuestionsController, :type => :controller do

  before(:each) do

    FactoryGirl.create :confirmed_user, {:email => "test@test.com"}
    FactoryGirl.create :question
  end
  # let(:valid_attributes) { { 
  #   title: "question title",
  #   body: "question body"
  #  } }


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
      get :show {:id => 1}
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
  end

  # describe "POST create" do
  #   it "returns http success" do
  #     question_params = FactoryGirl.attributes_for(:question)
  #     expect {post(:create, 
  #         {:question => question_params
  #         }
  #       ) 
  #     }.to change(Question, :count).by(1)
  #     expect(response).to have_http_status(:success)

  #   end
  # end

  # describe "GET edit" do
  #   it "returns http success" do
  #     get :edit
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET update" do
  #   it "returns http success" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET delete" do
  #   it "returns http success" do
  #     get :delete
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET destroy" do
  #   it "returns http success" do
  #     get :destroy
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
