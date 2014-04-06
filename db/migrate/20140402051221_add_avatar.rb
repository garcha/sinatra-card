class AddAvatar < ActiveRecord::Migration
  def change
    change_table :cards do |t|
        t.string :avatar
    end
  end
end
