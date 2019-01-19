Rails.application.routes.draw do
  post '/callback' => 'webhook#callback'
  get "/" => "gurunavi#show"
end
