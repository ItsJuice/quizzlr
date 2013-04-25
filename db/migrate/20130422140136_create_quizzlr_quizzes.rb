class CreateQuizzlrQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzlr_quizzes do |t|

      t.timestamps
    end
  end
end
