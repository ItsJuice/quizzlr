Quizzlr::Engine.routes.draw do

  resources :quizzes do
    post :results, on: :member, as: 'results_for'
  end

end
