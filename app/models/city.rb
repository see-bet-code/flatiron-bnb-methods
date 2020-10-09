class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  has_many :reservations, :through => :listings

  include Reservable

  def city_openings(s1 ,e1)
    openings(s1, e1)
  end


end

