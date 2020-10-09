class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :accepted, :checkout_has_happened

  private

  def accepted
    errors.add(:reservation, "Reservation has not been accepted.") if self.reservation && self.reservation.status != 'accepted'
  end

  def checkout_has_happened
    errors.add(:reservation, "Checkout has not happened.") if self.reservation && self.reservation.checkout > Time.now
  end
end
