class CreateBibleReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_readings do |t|
      t.string :book
      t.string :uid

      t.timestamps
    end
  end
end
