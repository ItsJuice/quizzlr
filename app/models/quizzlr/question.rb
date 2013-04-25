module Quizzlr
  class Question 
    include Mongoid::Document
    include Mongoid::Timestamps

    field :text
    field :image

    mount_uploader :image, Quizzlr::QuestionImageUploader

    embeds_many :answers, class_name: 'Quizzlr::Answer', inverse_of: :question
    embedded_in :quiz, class_name: 'Quizzlr::Quiz', inverse_of: :questions

    accepts_nested_attributes_for :answers, allow_destroy: true

    validates :text, presence: true
    validates :answers, :length => { :minimum => 1 }
    validate :must_have_one_correct_answer

    def must_have_one_correct_answer
      correct_answers = answers.where(correct: true).count
      if correct_answers > 1
        errors.add(:answers, "can't have more than 1 correct answer")
      elsif correct_answers < 1
        errors.add(:answers, "must have at least 1 correct answer")        
      end
    end
  end
end
