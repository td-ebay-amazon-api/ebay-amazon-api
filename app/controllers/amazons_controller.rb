class AmazonsController < ApplicationController



  def get_request

    #response = get_az_list     #Use this line for live use
    response = read_from_json   #Use this line for development/testing

    #render json: response.to_h  #Live use
    asin_list = extract_asins(response)
    render json: asin_list
  end

  def get_az_list
    key = ENV['AWS_ACCESS_KEY_ID']
    secret = ENV['AWS_SECRET_ACCESS_KEY']

    request = Vacuum.new
    request.configure(
     aws_access_key_id: key,
     aws_secret_access_key: secret,
     associate_tag: 'dollarsinyour-20'
    )

    params = {
    "BrowseNodeId" => "165793011",
    "ResponseGroup" => "MostGifted"
    }
    request.browse_node_lookup(
     query: params
    )
  end

  def read_from_json
    file = File.read(Rails.root.join('app', 'assets', 'json', 'most_gifted_toys.json'))
    JSON.parse(file)
  end

  def extract_asins(response)
    response = response.to_h
    asin_list = []
    response["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["TopItemSet"]["TopItem"].each do |item|
      asin_list << item["ASIN"]
    end
    asin_list
  end
end
