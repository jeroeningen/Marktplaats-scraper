class Advertisement < ActiveRecord::Base
  validates :advertisement_nr, :presence => true, :uniqueness => true
  validates :title, :presence => true
  validates :description, :presence => true
  validates :advertisement_owner_id, :presence => true
  validates :advertisement_owner_name, :presence => true
  validates :location, :presence => true
  validates :price, :presence => true
#  validates :price_type, :presence => true
  validates :datetime, :presence => true
  validates :url, :presence => true
end
