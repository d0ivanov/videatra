class CreateRolesTable < ActiveRecord::Migration

  def up
    if !Role.table_exists?
      create_table :roles do |t|
        t.string :role
      end

      create_table :roles_users do |t|
        t.belongs_to :user
        t.belongs_to :role

        t.timestamps
      end

      Role.new(role: 'admin').save!
      Role.new(role: 'colaborator').save!
      Role.new(role: 'subscriber').save!
    end
  end

  def down
    drop_table :roles_users
    drop_table :roles
  end
end
