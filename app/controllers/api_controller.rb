class ApiController < ApplicationController

  def make_a_comparison
    az_request = Amazon.new
    ebay_request = Ebay.new

    #Get list of products and pricing from Amazon
    product_list = az_request.make_a_request(params[:node_id])

    #Get prices of each product on eBay

    # product_list.each do |product|
    #   code to find a product on Ebay
    #   product.ebay_price = ebay_price
    #   product.ebay_link = ebay_link
    # end

    render json: product_list
  end
end
