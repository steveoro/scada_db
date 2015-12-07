ScadaDb::Engine.routes.draw do
  devise_for :admins, class_name: "ScadaDb::Admin", module: :devise
  devise_for :users,  class_name: "ScadaDb::User",  module: :devise

  root to: "home#index", locale: /en|it/
end
