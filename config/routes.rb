ScadaDb::Engine.routes.draw do
  root to: "home#index", locale: /en|it/
end
