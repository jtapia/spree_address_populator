object @user
attributes :id

address_fields = [:firstname, :lastname,
                  :address1, :address2,
                  :city, :zipcode,
                  :phone, :state_name,
                  :state_id, :country_id,
                  :company]

child :available_shipping_addresses => :ship_addresses do
  attributes *address_fields
  child :state do
    attributes :name, :id
  end

  child :country do
    attributes :name, :id
  end
end

child :available_billing_addresses => :bill_addresses do
  attributes :id
  attributes *address_fields
  child :state do
    attributes :name, :id
  end

  child :country do
    attributes :name, :id
  end
end