module Quizzlr
  class Answer
    include Mongoid::Document
    include Mongoid::Timestamps

    field :value
    field :correct, type: Boolean, default: false

    validates :value, presence: true

    embedded_in :question, class_name: 'Quizzlr::Question', inverse_of: :answers
  end
end