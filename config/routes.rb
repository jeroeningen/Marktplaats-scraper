MarktplaatsScraper::Application.routes.draw do
  root :to => "scrapers#index"
  resources :scrapers
end
