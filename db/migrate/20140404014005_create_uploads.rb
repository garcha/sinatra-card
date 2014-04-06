class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :filepath
      t.belongs_to :card
      t.timestamps
    end
  end
end
