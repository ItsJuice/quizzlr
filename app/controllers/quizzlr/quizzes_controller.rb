module Quizzlr
  class QuizzesController < ApplicationController

    def index
      @quizzes = Quizzlr::Quiz.all
    end

    def new
      @quiz = Quizzlr::Quiz.new 
    end

    def create
      @quiz = Quizzlr::Quiz.new params[:quiz]
      if @quiz.save
        redirect_to quizzes_path
      else
        render :new
      end
    end

    def show
      @quiz = Quizzlr::Quiz.find params[:id]
    end

    def edit
      @quiz = Quizzlr::Quiz.find params[:id]
    end

    def update
      @quiz = Quizzlr::Quiz.find params[:id]
      if @quiz.update_attributes(params[:quiz])
        redirect_to quizzes_path
      else
        render :edit
      end
    end

    def destroy
      @quiz = Quizzlr::Quiz.find params[:id]
      @quiz.destroy
      redirect_to quizzes_path
    end

    def results
      @quiz = Quizzlr::Quiz.find params[:id]
      respond_to do |format|
        format.json { render json: @quiz.results(params) }
      end
    end
  end
end