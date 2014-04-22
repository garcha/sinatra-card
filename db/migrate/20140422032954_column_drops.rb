class ColumnDrops < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.string :bloodtype
    end

    remove_column :cards, :address2
    remove_column :cards, :address3
    remove_column :cards, :phone
    remove_column :cards, :em_phone
    remove_column :cards, :doc_phone
    remove_column :cards, :insur_phone
    remove_column :cards, :avatar
    remove_column :cards, :address2
    remove_column :addresses, :address1
    remove_column :addresses, :address2
    remove_column :addresses, :phone

    drop_table :purchases
    drop_table :uploads

  end
end
