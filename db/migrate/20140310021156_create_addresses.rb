class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.belongs_to   :card
      t.string       :name
      t.string       :address
      t.string       :address1
      t.string       :address2
      t.integer      :phone
      t.string       :email
    end
  end

  def self.down
    drop_table :addresses
  end

end
