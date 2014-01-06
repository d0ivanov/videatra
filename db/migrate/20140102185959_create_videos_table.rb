class CreateVideosTable < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :thumbnail
      t.timestamps
    end
  end

  def down
  end
end
