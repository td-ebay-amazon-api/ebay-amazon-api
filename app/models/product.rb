class Product
  attr_accessor :title, :az_price, :upc, :az_link, :ebay_price, :ebay_link

  def initialize (title, az_price, az_link, upc)
    @title = title
    is_a_number(az_price) ? (@az_price = (az_price.to_f)/100) : (@az_price = az_price)
    @az_link = az_link
    @upc = upc
  end

  def is_a_number(input)
    true if Float(input) rescue false
  end
end
