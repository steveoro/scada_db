class AddRequiredParameters < ActiveRecord::Migration

  # (Required) Data migration
  def self.up
    ScadaDb::AppParameter.create!([
        # Versioning parameter:
        {
          code: ScadaDb::AppParameter::CODE_VERSIONING,
          str_1: ScadaDb::VERSION,
          str_2: ScadaDb::VERSION_DB,
          bool_1: false,
          description: "str_1: App/DB version, bool_1: maintenance mode toggle"
        }
    ])
  end


  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
