class CreateProfiles < ActiveRecord::Migration

  def up
    if !connection.table_exists? "profiles"
      create_table :profiles do |t|
        t.belongs_to :user
        t.string :first_name
        t.string :last_name
        t.string :country
        t.string :avatar

        t.timestamps
      end
    end
  end

  def down
    drop_table :profiles
  end
end
