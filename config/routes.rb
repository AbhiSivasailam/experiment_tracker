Rails.application.routes.draw do
  resources :experiments do
    collection do
      get :current
      get :past
      get :query_campaign
    end
  end

  root :to => 'experiments#current'
# resources :experiments
# get '/experiments' => 'experiments#index'
# post '/experiments' => 'experiments#create'
# get '/experiments/new' => 'experiments#new'
end