require "spec_helper"

describe Quizzlr::QuizzesController do
  describe "GET #index" do
    it "populates an array of quizzes" do
      quiz = FactoryGirl.create(:quiz, :with_questions)
      get :index
      assigns(:quizzes).entries.should eq([quiz])
    end 
    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end
  
  describe "GET #show" do
    it "assigns the requested quiz to @quiz" do
      quiz = FactoryGirl.create(:quiz, :with_questions)
      get :show, id: quiz
      assigns(:quiz).should eq quiz
    end 
    it "renders the :show template" do
      get :show, id: FactoryGirl.create(:quiz, :with_questions)
      response.should render_template :show
    end
  end
  
  describe "GET #new" do
    it "assigns a new Quiz to @quiz" do
      get :new
      assigns(:quiz).new_record?.should eq true
    end 
    it "renders the :new template" do
      get :new
      response.should render_template :new
    end
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new quiz in the database" do
        expect{
          post :create, quiz: build_quiz_attributes(FactoryGirl.build(:quiz, :with_questions))
        }.to change(Quizzlr::Quiz,:count).by(1)
      end
      it "redirects to the index page" do
        post :create, quiz: build_quiz_attributes(FactoryGirl.build(:quiz, :with_questions))
        response.should redirect_to quizzes_url
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new quiz in the database" do 
        expect{
          post :create, quiz: build_quiz_attributes(FactoryGirl.build(:quiz))
        }.to_not change(Quizzlr::Quiz,:count)
      end
      it "re-renders the :new template" do 
        post :create, quiz: build_quiz_attributes(FactoryGirl.build(:quiz))
        response.should render_template :new
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested quiz to @quiz" do
      quiz = FactoryGirl.create(:quiz, :with_questions)
      get :edit, id: quiz
      assigns(:quiz).should eq quiz
    end 
    it "renders the :edit template" do
      get :edit, id: FactoryGirl.create(:quiz, :with_questions)
      response.should render_template :edit
    end
  end

  describe "PUT #update" do
    before :each do
      @quiz = FactoryGirl.create(:quiz, :with_questions)
    end

    context "with valid attributes" do
      it "located the requested @quiz" do
        put :update, id: @quiz, quiz: build_quiz_attributes(@quiz)
        assigns(:quiz).should eq(@quiz)      
      end

      it "changes @quiz's attributes" do
        @quiz.name = "Testing"
        @quiz.description = "Testing changing the description"
        put :update, id: @quiz, quiz: build_quiz_attributes(@quiz)
        @quiz.reload
        @quiz.name.should eq("Testing")
        @quiz.description.should eq("Testing changing the description")
      end
    
      it "redirects to the index page" do
        put :update, id: @quiz, quiz: build_quiz_attributes(@quiz)
        response.should redirect_to quizzes_path
      end
    end

    context "with invalid attributes" do
      it "located the requested @quiz" do
        put :update, id: @quiz, quiz: FactoryGirl.attributes_for(:quiz)
        assigns(:quiz).should eq(@quiz)      
      end

      it "does not change @quiz's attributes" do
        @quiz.name = ""
        put :update, id: @quiz, quiz: build_quiz_attributes(@quiz)
        @quiz.reload
        @quiz.name.should_not eq("Testing")
      end

      it "renders the :edit template" do
        @quiz.name = ""
        put :update, id: @quiz, quiz: build_quiz_attributes(@quiz)
        response.should render_template :edit
      end

    end
  end

  describe 'DELETE destroy' do
    before :each do
      @quiz = FactoryGirl.build(:quiz, :with_questions)
      @quiz.save!
    end
    
    it "deletes the quiz" do
      expect{
        delete :destroy, id: @quiz        
      }.to change(Quizzlr::Quiz,:count).by(-1)
    end
      
    it "redirects to quizzes#index" do
      delete :destroy, id: @quiz
      response.should redirect_to quizzes_url
    end
  end

  def build_quiz_attributes quiz
    quiz_attr = quiz.attributes
    questions_attributes = {}
    quiz.questions.each_with_index do |q, i|
      att = q.attributes.reject! { |k| k == "_id" }
      answers_attributes = {}
      q.answers.each_with_index do |a, j|
        answers_attributes[j.to_s] = a.attributes.reject! { |k| k == "_id" }
      end 
      att["answers_attributes"] = answers_attributes
      questions_attributes[i.to_s] = att
    end 
    quiz_attr["questions_attributes"] = questions_attributes
    quiz_attr
  end
end