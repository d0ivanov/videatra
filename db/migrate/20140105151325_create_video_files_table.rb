class CreateVideoFilesTable < ActiveRecord::Migration
  def up
    create_table :video_files do |t|
      t.belongs_to :video
      t.string :content_type
      t.string :file

      t.timestamps
    end
  end

  def down
  end
end
