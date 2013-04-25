FactoryGirl.define do

  trait :with_questions do 
    ignore do
      number_of_questions 3
      number_of_answers 3
      number_of_correct_answers 1
    end

    after :build do |quiz, evaluator|
      questions = FactoryGirl.build_list :question, evaluator.number_of_questions, :with_answers, quiz: quiz, number_of_answers: evaluator.number_of_answers, number_of_correct_answers: evaluator.number_of_correct_answers
    end
  end

  trait :with_answers do 
    ignore do
      number_of_answers 3
      number_of_correct_answers 1
    end

    after :build do |question, evaluator|
      answers = FactoryGirl.build_list :answer, (evaluator.number_of_answers-1), question: question
      answers.concat FactoryGirl.build_list(:correct_answer, (evaluator.number_of_correct_answers), question: question)
    end
  end
    
  factory :quiz, class: Quizzlr::Quiz do
    name { Forgery(:lorem_ipsum).words(6) }
    description { Forgery(:lorem_ipsum).words(50) }
  end

  factory :question, class: Quizzlr::Question do
    text { "#{Forgery(:lorem_ipsum).words(50)}?" }
    quiz
  end

  factory :answer, class: Quizzlr::Answer do
    value { "#{Forgery(:lorem_ipsum).words(50)}?" }
    correct false

    factory :correct_answer, class: Quizzlr::Answer do
      correct true
    end

    question
  end
end