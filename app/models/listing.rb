class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, 
    :price, :neighborhood, presence: true

  before_create :change_user_host_to_true
  before_destroy :change_user_host_to_false
  
  def available?(s1, e1)
    self.reservations.none? do |r| 
      (r.checkin.to_formatted_s..r.checkout.to_formatted_s).overlaps?(s1..e1)
    end
  end

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def change_user_host_to_true
    self.host.update(host: true)
  end

  def change_user_host_to_false 
    self.host.update(host: false) if self.host.listings.where.not(id: self.id).empty?
  end
end
