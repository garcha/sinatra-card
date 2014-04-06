class AddTimeDate < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
        t.timestamps
    end
  end
end
