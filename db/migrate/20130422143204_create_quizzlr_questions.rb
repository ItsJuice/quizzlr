class CreateQuizzlrQuestions < ActiveRecord::Migration
  def change
    create_table :quizzlr_questions do |t|

      t.timestamps
    end
  end
end
