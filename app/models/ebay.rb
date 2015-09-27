require 'open-uri'

class Ebay

  attr_reader :results, :keyword

  def initialize
    @dev_id = ENV['EBAY_DEVID'] #same between sandbox/prod
    @app_id_sandbox = ENV['EBAY_APPID_SANDBOX']
    @cert_id_sandbox = ENV['EBAY_CERTID_SANDBOX']
    @app_id = ENV['EBAY_APPID']
    @cert_id = ENV['EBAY_CERTID']

    @results = nil
    @keyword = nil
  end

  def cheapest_result(keyword: nil)
    if keyword
      search(keyword: keyword) if @results.nil? || keyword != @keyword
    end
    @results.sort_by { |r| r["total_price"] }.first
  end

  def search(keyword:, entries: 10, sandbox: false)
    return @results if @keyword == keyword
    reference = get_reference_id(keyword: keyword)
    sandbox ? app_id = @app_id_sandbox : app_id = @app_id
    ebay_url = "http://svcs.ebay.com/services/search/FindingService/v1"
    ebay_url << "?OPERATION-NAME=findItemsByProduct"
    ebay_url << "&SERVICE-VERSION=1.0.0"
    ebay_url << "&GLOBAL-ID=EBAY-US"
    ebay_url << "&SECURITY-APPNAME=#{@app_id}"
    ebay_url << "&RESPONSE-DATA-FORMAT=JSON"
    ebay_url << "&REST-PAYLOAD="
    ebay_url << "&buyerPostalCode=#{get_ip_zip}"
    ebay_url << "&itemFilter(0).name=Condition"
    ebay_url << "&itemFilter(0).value(0)=1000"
    ebay_url << "&itemFilter(0).value(1)=1500"
    ebay_url << "&itemFilter(0).value(2)=2000"
    ebay_url << "&itemFilter(1).name=Currency"
    ebay_url << "&itemFilter(1).value(0)=USD"
    ebay_url << "&itemFilter(2).name=ListingType"
    ebay_url << "&itemFilter(2).value(0)=AuctionWithBIN"
    ebay_url << "&itemFilter(2).value(1)=FixedPrice"
    ebay_url << "&itemFilter(3).name=LocatedIn"
    ebay_url << "&itemFilter(3).value(0)=US"
    ebay_url << "&productId.@type=ReferenceID"
    ebay_url << "&productId=#{reference}"
    ebay_url << "&paginationInput.entriesPerPage=#{entries}"
    ebay_url << "&sortOrder=PricePlusShippingLowest"

    response = JSON.parse(open(URI.escape(ebay_url)).read)
    matches = []
    response["findItemsByProductResponse"][0]["searchResult"][0]["item"].each do |p|
      shipping_cost = p["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].to_f
      buy_it_now_price = p["sellingStatus"][0]["convertedCurrentPrice"][0]["__value__"].to_f
      matches << {
        item_id: "#{p["itemId"][0]}",
        category_name: "#{p["primaryCategory"][0]["categoryName"][0]}",
        shipping_cost: shipping_cost,
        buy_it_now_price: buy_it_now_price,
        total_price: shipping_cost + buy_it_now_price,
        condition: "#{p["condition"][0]["conditionDisplayName"][0]}",
        url: "http://www.ebay.com/itm/#{p['itemId'][0]}"
      }
    end
    @keyword = keyword
    @results = matches
    matches
  end



  def get_reference_id(keyword:, sandbox: false)
    sandbox ? app_id = @app_id_sandbox : app_id = @app_id
    ebay_url = "http://open.api.ebay.com/shopping?"
    ebay_url << "callname=FindProducts"
    ebay_url << "&responseencoding=JSON"
    ebay_url << "&appid=#{@app_id}"
    ebay_url << "&siteid=0"
    ebay_url << "&version=525"
    ebay_url << "&QueryKeywords=#{URI.escape(keyword)}"
    ebay_url << "&AvailableItemsOnly=true"
    ebay_url << "&MaxEntries=1"
    response = JSON.parse(open(URI.escape(ebay_url)).read)
    response["Product"].first["ProductID"][0]["Value"]
  end

  def get_ip_zip(zip: nil)
    zip = open('http://whatismyip.akamai.com').read unless zip
    zip_url = "http://geocoder.ca/#{zip}?json=1"
    JSON.parse(open(zip_url).read)["usa"]["zip"] || ""
  end

end



