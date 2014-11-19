$(document).ready ->
  # Initialize a couple empty Select2 before the user is loaded.
  $("#billing_address_select").select2 { data: [] }
  $("#shipping_address_select").select2 { data: [] }

  # Format the items in the list so that you get the format:
  # <firstname> <lastname>
  # <company>
  # <address one>
  # <address two>
  # <city>, <state>
  # <country>
  formatAddress = (item) ->
    text = ""
    if item.firstname && item.firstname.length > 0 && item.lastname && item.lastname.length > 0
      text += item.firstname + " " + item.lastname + "<br />"
    if item.company && item.company.length > 0
      text += item.company + "<br />"
    if item.address1 && item.address1.length > 0
      text += item.address1 + "<br />"
    if item.address2 && item.address2.length > 0
      text += item.address2 + "<br />"
    if item.city && item.city.length > 0
      text += item.city + ", "
    if item.state_name && item.state_name.length > 0
      text += item.state_name + "<br />"
    if item.country_name && item.country_name.length > 0
      text += item.country_name
    text

  # Format the address on a single line for when the address is selected.
  formatSingleLineAddress = (item) ->
    text = []
    if item.firstname && item.firstname.length > 0 && item.lastname && item.lastname.length > 0
      text.push item.firstname + " " + item.lastname
    if item.company && item.company.length > 0
      text.push item.company
    if item.address1 && item.address1.length > 0
      text.push item.address1
    if item.address2 && item.address2.length > 0
      text.push item.address2
    if item.city && item.city.length > 0
      text.push item.city
    if item.state_name && item.state_name.length > 0
      text.push item.state_name
    if item.country_name && item.country_name.length > 0
      text.push item.country_name
    text.join ", "

  populateAddressBox = (address_type, addresses) ->
    data = generateFormat addresses
    $("#" + address_type + "_address_select").select2
      data: { results: data },
      results: (data) -> results: data,
      formatSelection: formatSingleLineAddress,
      formatResult: formatAddress

  generateFormat = (addresses) ->
    data = []

    for address, i in addresses
      if address.state && address.state.id
        data.push
          id: i
          firstname: address.firstname,
          lastname: address.lastname,
          company: address.company,
          address1: address.address1,
          address2: address.address2,
          city: address.city,
          zipcode: address.zipcode,
          phone: address.phone,
          country_id: address.country.id,
          country_name: address.country.name,
          state_id: address.state.id,
          state_name: address.state.name

    return data

  loadAddresses = (customer_id) ->
    $.get "/admin/search/addresses", { q: customer_id }, (data) ->
      if data.bill_addresses != null && data.bill_addresses.length > 0
        populateAddressBox "billing", data.bill_addresses
        populateFirstTime "bill", data.bill_addresses[0]
      if data.ship_addresses != null && data.ship_addresses.length > 0
        populateAddressBox "shipping", data.ship_addresses
        populateFirstTime "ship", data.ship_addresses[0]

  populateFirstTime = (address_type, address) ->
    data = [address]
    addressFormat = generateFormat(data)
    populateAddressFields address_type, addressFormat[0]

  # Modified from update script on the Spree core.
  updateState = (country_id, selected_state_name, selected_state_id, address_type) ->
    $.get Spree.routes.states_search + '?country_id=' + country_id, (data) ->
      states = data.states
      state_select = $("#order_" + address_type + "_address_attributes_state_id")
      state_input = $("#order_" + address_type + "_address_attributes_state_name")
      if states.length > 0
        state_select.html ''
        states_with_blank = [{
          name: '',
          id: ''
        }].concat(states)
        $.each states_with_blank, (pos, state) ->
          opt = $(document.createElement('option'))
            .attr('value', state.id)
            .html(state.name)
          state_select.append(opt)
        state_select.prop('disabled', false).show()
        state_select.select2()
        state_input.hide().prop('disabled', true)
      else
        state_input.prop('disabled', false).show()
        state_select.select2('destroy').hide()
      state_select.select2().select2 "data", { id: selected_state_id, text: selected_state_name }

  populateAddressFields = (address_type, address_data) ->
    $("#order_" + address_type + "_address_attributes_firstname").val address_data.firstname
    $("#order_" + address_type + "_address_attributes_lastname").val address_data.lastname
    $("#order_" + address_type + "_address_attributes_company").val address_data.company
    $("#order_" + address_type + "_address_attributes_address1").val address_data.address1
    $("#order_" + address_type + "_address_attributes_address2").val address_data.address2
    $("#order_" + address_type + "_address_attributes_city").val address_data.city
    $("#order_" + address_type + "_address_attributes_zipcode").val address_data.zipcode
    $("#order_" + address_type + "_address_attributes_phone").val address_data.phone
    $("#order_" + address_type + "_address_attributes_country_id").select2().select2 "data", { id: address_data.country_id, text: address_data.country_name }
    updateState(address_data.country_id, address_data.state_name, address_data.state_id, address_type)

  $("#customer_search").change ->
    user_id = $('#user_id').val()
    loadAddresses user_id

  $("#billing_address_select").change ->
    populateAddressFields "bill", $("#billing_address_select").select2("data")

  $("#shipping_address_select").change ->
    populateAddressFields "ship", $("#shipping_address_select").select2("data")