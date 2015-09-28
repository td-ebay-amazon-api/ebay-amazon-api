require 'test_helper'
require './app/models/amazon.rb'
require 'byebug'
class Amazon
  def get_az_list(a, b)
    file = File.read(Rails.root.join('app', 'assets', 'json', 'most_gifted_toys.json'))
    @response = JSON.parse(file)
  end
end

class AmazonTest < ActionController::TestCase
  test "can create object" do
    assert Amazon.new
  end

  test "can get AZ most x list" do
    request = Amazon.new
    request.get_az_list(1, 2)
    assert request.response.to_h.to_s.include?("Cards Against Humanity")
  end

  test "can get ASINS" do
    request = Amazon.new
    request.get_az_list(1, 2)
    asin_list = request.extract_asins

    assert asin_list.include?("B003WFKOSS")
  end

  test "can get UPC and price list" do
    request = Amazon.new
    response = request.make_a_request("2625373011", "NewReleases")
    assert response[0].title.include?("Cards Against Humanity")
  end
end
