class CreateAdvertisements < ActiveRecord::Migration
  def self.up
    create_table :advertisements do |t|
      t.integer :advertisement_nr
      t.string :title
      t.text :description
      t.integer :advertisement_owner_id
      t.string :advertisement_owner_name
      t.string :location
      t.integer :price
      t.string :price_type
      t.datetime :datetime
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :advertisements
  end
end
