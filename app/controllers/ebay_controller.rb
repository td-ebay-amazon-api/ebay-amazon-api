require 'open-uri'

class EBayController < APIController

  @dev_id = ENV['EBAY_DEVID'] #same between sandbox/prod
  @app_id_sandbox = ENV['EBAY_APPID_SANDBOX']
  @cert_id_sandbox = ENV['EBAY_CERTID_SANDBOX']
  @app_id = ENV['EBAY_APPID']
  @cert_id = ENV['EBAY_CERTID']

  def initialize
  end

  def get_ip_zip(zip: nil)
    zip = open('http://whatismyip.akamai.com').read unless zip
    url = "http://geocoder.ca/
            #{zip}
            ?json=1"
    JSON.parse(open(url).read)["usa"]["zip"] || ""
  end

  def get_results(ebay_reference_id:, sandbox: false)
    sandbox ? app_id = @app_id_sandbox : app_id = @app_id
    url = "http://svcs.ebay.com/services/search/FindingService/v1
            ?OPERATION-NAME=findItemsByProduct
            &SERVICE-VERSION=1.0.0
            &GLOBAL-ID=EBAY-US
            &SECURITY-APPNAME=
            &RESPONSE-DATA-FORMAT=JSON
            &REST-PAYLOAD=
            &buyerPostalCode=#{get_ip_zip}
            &itemFilter(0).name=Condition
            &itemFilter(0).value(0)=1000
            &itemFilter(0).value(1)=1500
            &itemFilter(0).value(2)=2000
            &itemFilter(1).name=Currency
            &itemFilter(1).value(0)=USD
            &itemFilter(2).name=ListingType
            &itemFilter(2).value(0)=AuctionWithBIN
            &itemFilter(2).value(1)=FixedPrice
            &itemFilter(3).name=LocatedIn
            &itemFilter(3).value(0)=US
            &productId.@type=#{ebay_reference_id}
            &productId=#{get_ebay_reference_id(keyword)}
            &paginationInput.entriesPerPage=10
            &sortOrder=PricePlusShippingLowest"
    response = JSON.parse(open(URI.escape(url)).read)
    matches = []
    response["findItemsByProductResponse"]["searchResult"]["item"].each do |p|
      matches << {

      }
    matches
    end


  end

  def get_ebay_reference_id(keyword:, sandbox: false)
    sandbox ? app_id = @app_id_sandbox : app_id = @app_id
    url = "http://open.api.ebay.com/shopping?
             callname=FindProducts&
             responseencoding=JSON&
             appid=#{app_id}&
             siteid=0&
             version=525&
             QueryKeywords=#{URI.escape(keyword)}&
             AvailableItemsOnly=true&
             MaxEntries=10"
    response = JSON.parse(open(URI.escape(url)).read)
    potential_title_matches = []
    response["Product"].each { |p| potential_title_matches << p["Title"] }
    product_index = potential_title_matches.each { |p| p.starts_with?(keyword) break p.index }
    product_id_index = response["Product"][product_index].each { |pid| pid["Type"] == "Reference" break pid.index }
    response["Product"][product_index]["ProductID"][product_id_index]["Value"]
  end


# http://svcs.ebay.com/services/search/FindingService/v1?
#    OPERATION-NAME=findItemsByProduct&
#    SERVICE-VERSION=1.0.0&
#    SECURITY-APPNAME=@app_id_sandbox&
#    RESPONSE-DATA-FORMAT=JSON&
#    REST-PAYLOAD&
#    paginationInput.entriesPerPage=10&
#    productId.@type=UPC&
#    productId=53039031

end
