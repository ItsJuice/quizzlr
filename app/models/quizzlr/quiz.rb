module Quizzlr
  class Quiz
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :name
    field :description
    field :intro_image
    field :final_image
    embeds_many :questions, class_name: 'Quizzlr::Question', inverse_of: :quiz, cascade_callbacks: true

    accepts_nested_attributes_for :questions, :allow_destroy => true

    mount_uploader :intro_image, Quizzlr::QuizImageUploader
    mount_uploader :final_image, Quizzlr::QuizImageUploader

    validates :name, presence: true
    validates :questions, :length => { :minimum => 1 }

    def results params
      correct_answers = 0

      questions.each do |q|
        answer = q.answers.find params[q.id.to_s]
        correct_answers += 1 if answer.correct
      end

      {correct_answers: correct_answers}

    end
  end
end
