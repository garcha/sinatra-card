class ChangeAddress < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.string :city
      t.string :state
      t.string :zip
    end

    change_table :addresses do |t|
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
