class ApiController < ApplicationController

  def make_a_comparison
    az_request = Amazon.new
    ebay_request = Ebay.new

    #Get list of products and pricing from Amazon
    product_list = az_request.make_a_request(params[:node_id],params[:list_type])

    #Get prices of each product on eBay
    product_list.each do |product|
      product.ebay_price = nil
      product.ebay_link = nil
      next unless product.upc
      next if product.upc == "0"
      cheapest_ebay_result = ebay_request.search(upc: product.upc, entries: 1)
      if cheapest_ebay_result.length > 0
        product.ebay_price = cheapest_ebay_result[0][:total_price]
        product.ebay_link = cheapest_ebay_result[0][:url]
      end
    end

    render json: product_list
  end
end
