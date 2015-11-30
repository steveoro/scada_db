Rails.application.routes.draw do

  mount ScadaDb::Engine => "/scada_db"
end
