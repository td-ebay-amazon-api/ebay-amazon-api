require 'test_helper'

class EbayTest < ActionController::TestCase
  testfile = JSON.parse(File.read(Rails.root.join('test', 'fixtures', 'ebay_response.json')))
  test "can create object" do
    assert Ebay.new(response: testfile)
  end

  test "can get ebay response" do
    request = Ebay.new(response: testfile)
    assert request.response.to_s.include?("Mario Maker")
  end

  test "can get matches and prices" do
    request = Ebay.new(response: testfile)
    response = request.search(upc: "045496903756")[0]
    assert response[:total_price].to_f == 50.0
    assert response[:category_name] == "Video Games"
  end
end
