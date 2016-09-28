Rails.application.routes.draw do
  get "/pages/integration" => "pages#integration" #hubstaff email/password form
  post "/pages/integration" => "pages#integration", as: :integration #process email/password

  get "/pages/screenshots" => "pages#screenshots", as: :screenshots #display screenshots
  get "/pages/activities" => "pages#activities", as: :activities #display activities

  root to: "pages#show", id: "home"
end
