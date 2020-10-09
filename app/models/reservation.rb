class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_different, :available, :checkin_before_checkout

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def guest_and_host_different
    errors.add(:guest_id, "You cannot make a reservation on your own listing.") if self.guest == self.listing.host
  end

  def available
    cond = Reservation.where(listing_id: listing.id).where.not(id: id).any? do |r|
      (self.checkin..self.checkout).overlaps?(r.checkin..r.checkout) if self.checkin && self.checkout
    end
    errors.add(:guest_id, "Listing is unavaible for selected date(s).") if cond 
  end

  def checkin_before_checkout
    errors.add(:guest_id, "Checkin must be before checkout.") if self.checkin && self.checkout && self.checkin >= self.checkout
  end
end
