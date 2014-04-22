class ChangeCards < ActiveRecord::Migration
  def up
    change_table :cards do |t|
      t.string :phone1
      t.string :phone_doc
      t.string :phone_em
    end

    change_table :addresses do |t|
      t.string :phone1
    end
  end
end
