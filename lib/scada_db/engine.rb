module ScadaDb
  class Engine < ::Rails::Engine
    isolate_namespace ScadaDb

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    # [Steve, 20151207] This will forcibly make all written migrations
    # available also automatically to any mounting app:
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end
  end
end
