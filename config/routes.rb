Rails.application.routes.draw do
  get "/pages/integration" => "pages#integration"
  post "/pages/integration" => "pages#integration", as: :integration

  get "/pages/screenshots" => "pages#screenshots", as: :screenshots
  get "/pages/activities" => "pages#activities", as: :activities

  root to: "pages#show", id: "home"
end
