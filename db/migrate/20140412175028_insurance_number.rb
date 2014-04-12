class InsuranceNumber < ActiveRecord::Migration
  def up
    change_table :cards do |t|
      t.string :phone_insur
    end
  end
end
