Spree::User.class_eval do

  def available_shipping_addresses(excluding_address = nil)
    available_shipping_addresses = []
    unique_addresses = []
    ship_addresses.each{|address|
      unless (address == excluding_address) || unique_addresses.any?{ |unique_address| unique_address == address }
        available_shipping_addresses << address
        unique_addresses << address
      end
    }

    available_shipping_addresses.sort_by{ |address| address.id }.reverse.first(3)
  end

  def available_billing_addresses(excluding_address = nil)
    available_billing_addresses = []
    unique_addresses = []
    bill_addresses.each{ |address|
      unless (address == excluding_address) || unique_addresses.any?{ |unique_address| unique_address == address }
        available_billing_addresses << address
        unique_addresses << address
      end
    }

    available_billing_addresses.sort_by{ |address| address.id }.reverse.first(3)
  end

end