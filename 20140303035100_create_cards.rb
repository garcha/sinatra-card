class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string    :name
      t.string    :address1
      t.string    :address2
      t.string    :address3
      t.string    :dob
      t.integer   :phone
      t.string    :em_contact
      t.integer   :em_phone
      t.string    :doctor
      t.integer   :doc_phone
      t.string    :insurance
      t.string    :insur_numner
      t.integer   :insur_phone
      t.string    :medical_history1
      t.string    :medical_history2
      t.string    :medical_history3
      t.string    :medical_history4
      t.string    :medical_history5
      t.string    :medication1
      t.string    :medication2
      t.string    :medication3
      t.string    :medication4
      t.string    :medication5
      t.boolean   :pvc
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
