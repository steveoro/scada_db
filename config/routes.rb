ScadaDb::Engine.routes.draw do
  devise_for :admins, class_name: "ScadaDb::Admin"
  devise_for :users, class_name: "ScadaDb::User"
  root to: "home#index", locale: /en|it/
end
