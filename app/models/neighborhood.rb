class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  has_many :reservations, :through => :listings
  
  include Reservable

  def neighborhood_openings(s1, e1)
    openings(s1, e1)
  end
end
