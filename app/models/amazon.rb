class Amazon

  attr_reader :response, :product_info

  def get_az_list(node_id, list_type)
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
    "ResponseGroup" => list_type
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
    #Define search query parameters
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
    #Reads locally stored data. For testing/development only.
    file = File.read(Rails.root.join('app', 'assets', 'json', 'most_gifted_toys.json'))
    @response = JSON.parse(file)
  end

  def extract_asins
    #ASIN is a unique Amazon identifier for each listing
    #These must be extracted from the top lists to look
    #up each item individually.
    asin_list = []
    @response["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["TopItemSet"]["TopItem"].each do |item|
      asin_list << item["ASIN"]
    end
    asin_list
  end

  def get_upc_price_list(asin_list)
    product_information = []
    index = 0
    asin_list.each do |asin|
      response = get_az_product(asin)
      if response["ItemLookupResponse"]["Items"]["Request"]["Errors"]
        title = "Item not available through this API"
        upc = nil
        price = nil
      else
        title = response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
        upc = response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["UPC"]
        az_link = response["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"]
        begin
          price = response["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["Amount"]
        rescue
          price = nil
        end
      end
      product_information[index] = Product.new(title, price, az_link, upc)
      index += 1
      #Must delay while looping to avoid 503 from Amazon API
      sleep 0.4 unless index == 9
    end
    product_information
  end

  def make_a_request(node_id, list_type)
    get_az_list(node_id, list_type)     #Live
    #read_from_json  #Development/testing
    asin_list = extract_asins
    get_upc_price_list(asin_list)
  end
end
