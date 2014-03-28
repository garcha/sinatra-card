class ChangeCard < ActiveRecord::Migration
  def change
    change_table :cards do |t|
        t.string :picture
    end
  end
end
