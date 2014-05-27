class CreateSubscriptionPlan < ActiveRecord::Migration

  def up
    if !SubscriptionPlan.table_exists?
      create_table :subscription_plans do |t|
        t.string :name
        t.text :description
        t.integer :duration
        t.float :price
      end

      create_table :subscription_plans_videos do |t|
        t.belongs_to :video
        t.belongs_to :subscription_plan
      end

      create_table :subscription_plans_users do |t|
        t.belongs_to :user
        t.belongs_to :subscription_plan
        t.timestamps
      end
      SubscriptionPlan.new(name: 'Free', duration: 365, price: 0).save!
    end
  end

  def down
  end
end
