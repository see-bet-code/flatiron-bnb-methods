module Reservable
    extend ActiveSupport::Concern
    
    def openings(start_date, end_date)
        self.listings.filter { |list| list.available?(start_date,end_date) }
    end
    
    def ratio_res_to_listings
        self.listings.count > 0 ? self.reservations.count.to_f / self.listings.count : -1
    end
    
    class_methods do
        def highest_ratio_res_to_listings
            self.all.max_by { |loc| loc.ratio_res_to_listings }
        end
    
        def most_res
            self.all.max_by { |loc| loc.reservations.size }
        end
    end
end