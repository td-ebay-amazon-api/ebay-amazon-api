class Product
  attr_accessor :title, :az_price, :upc

  def initialize (title, price, upc)
    @title = title
    @az_price = (price.to_f)/100
    @upc = upc
  end
end
