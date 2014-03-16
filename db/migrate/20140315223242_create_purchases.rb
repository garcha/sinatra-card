class CreatePurchases < ActiveRecord::Migration
  def self.up
		create_table :purchases do |t|
			t.belongs_to 	:address
			t.string 			:stripeEmail
			t.string			:stripeToken
			t.timestamps
		end
  end

	def self.down
		drop_table :purchases
	end
end
