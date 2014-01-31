require_relative 'rolify/migrate/create_roles_table'
require_relative 'rolify/models/user'
require_relative 'rolify/models/role'

PlugMan.define :rolify do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: []})
  requires [:main]
  extension_points []
  params()

  def start
    CreateRolesTable.new.up
    true  
  end
end
