class CreateUsersTable < ActiveRecord::Migration

	def up
		create_table :users do |t|
			t.string :email,              :null => false, :defautl => ""
			t.string :encrypted_password, :null => false, :default => ""

			t.string  :remember_token
			t.boolean :remember_me

			t.timestamps
		end

		add_index :users, :email,          :unique => true
		add_index :users, :remember_token, :unique => true
	end

  def down
  end
end
