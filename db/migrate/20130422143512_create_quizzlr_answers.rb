class CreateQuizzlrAnswers < ActiveRecord::Migration
  def change
    create_table :quizzlr_answers do |t|

      t.timestamps
    end
  end
end
