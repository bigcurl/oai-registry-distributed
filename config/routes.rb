OaiRegistryDistributed::Application.routes.draw do

  get "api" => 'api#index'
  get "api/:uuid" => 'api#show'
  post "api" => 'api#create'
end
