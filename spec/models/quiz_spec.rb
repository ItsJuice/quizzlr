require "spec_helper"

describe Quizzlr::Quiz do
  context 'validations' do
    it "has a valid factory" do
      FactoryGirl.build(:quiz, :with_questions).should be_valid
    end

    it "is invalid without any questions" do
      FactoryGirl.build(:quiz, :with_questions, number_of_questions: 0).should_not be_valid
    end
    
    it "is invalid if questions do not have answers" do
      FactoryGirl.build(:quiz, :with_questions, number_of_answers: 0, number_of_correct_answers: 0).should_not be_valid
    end
    
    it "is invalid if questions have no correct answers" do
      FactoryGirl.build(:quiz, :with_questions, number_of_correct_answers: 0).should_not be_valid
    end
    
    it "is invalid if questions have more than one correct answer" do
      FactoryGirl.build(:quiz, :with_questions, number_of_correct_answers: 2).should_not be_valid
    end
  end

  context 'results' do
    before (:all) do
      @quiz = FactoryGirl.build(:quiz, :with_questions, number_of_questions:15)
      @quiz.save
    end

    # convert to a hash of params
    def get_answers quiz, number_correct
      Hash[quiz.questions.each_with_index.map { |q,i| [q._id.to_s, q.answers.where(correct: i < number_correct).first._id.to_s] }] 
    end

    it "can calculate no correct results" do
      answers = get_answers(@quiz, 0)
      @quiz.results(answers)[:correct_answers].should eq 0
    end

    it "can calculate some correct results" do
      answers = get_answers(@quiz, 10)
      @quiz.results(answers)[:correct_answers].should eq 10
    end

    it "can calculate all correct results" do
      answers = get_answers(@quiz, 15)
      @quiz.results(answers)[:correct_answers].should eq 15
    end
  end
end