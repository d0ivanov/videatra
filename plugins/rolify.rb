require_relative 'rolify/models/user'
require_relative 'rolify/models/role'
require_relative 'rolify/migrate/create_roles_table'

PlugMan.define :rolify do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: []})
  requires [:main]
  extension_points []
  params()

  CreateRolesTable.new.up
end
