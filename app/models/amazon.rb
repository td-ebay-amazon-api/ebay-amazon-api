class Amazon

  attr_reader :response, :product_info

  def initialize
    @response
    @product_info
  end

  def get_az_list(node_id)
    #Look up a list of products within a category
    key = ENV['AWS_ACCESS_KEY_ID']
    secret = ENV['AWS_SECRET_ACCESS_KEY']

    request = Vacuum.new
    request.configure(
     aws_access_key_id: key,
     aws_secret_access_key: secret,
     associate_tag: 'dollarsinyour-20'
    )

    query_params = {
    "BrowseNodeId" => node_id,
    "ResponseGroup" => "MostGifted"
    }
    @response = request.browse_node_lookup(
     query: query_params
    )
    @response = @response.to_h
  end

  def get_az_product(asin)
    #Look up an individual product on Amazon
    key = ENV['AWS_ACCESS_KEY_ID']
    secret = ENV['AWS_SECRET_ACCESS_KEY']

    #Create a Vacuum object to structure the Amazon query
    request = Vacuum.new
    request.configure(
     aws_access_key_id: key,
     aws_secret_access_key: secret,
     associate_tag: 'dollarsinyour-20'
    )

    query_params = {
      "ItemId" => asin,
      "IdType" => "ASIN",
      "ResponseGroup" => "ItemAttributes,OfferSummary",
      "Condition" => "New"
    }
    @product_info = request.item_lookup(
     query: query_params
    )
    @product_info = @product_info.to_h
  end

  def read_from_json
    file = File.read(Rails.root.join('app', 'assets', 'json', 'most_gifted_toys.json'))
    @response = JSON.parse(file)
  end

  def extract_asins
    asin_list = []
    @response["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["TopItemSet"]["TopItem"].each do |item|
      asin_list << item["ASIN"]
    end
    asin_list
  end

  def get_upc_price_list(asin_list)
    product_information = {}
    index = 0
    asin_list.each do |asin|
      response = get_az_product(asin)
      if response["ItemLookupResponse"]["Items"]["Request"]["Errors"]
        title = "Item not available through this API"
        upc = 0
        price = 0
      else
        title = response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
        upc = response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["UPC"]
        begin
          price = response["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["Amount"]
        rescue
          price = 0
        end
      end
      product_information[index] = Product.new(title, price, upc)
      index += 1
      sleep 0.4
    end
    product_information
  end

  def make_a_request(node_id)
    get_az_list(node_id)     #Live
    #read_from_json  #Development/testing
    asin_list = extract_asins
    get_upc_price_list(asin_list)
  end
end
