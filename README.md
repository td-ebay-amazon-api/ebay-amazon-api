# TD eBay-Amazon API

## What it does

This API allows a user to find a list of the most popular products on Amazon
within a given category and compare the prices of each product to those on eBay
to determine where the best deals are between the two e-commerce giants.

## How to Use

1. Clone the repository
2. Run `bundle install`
3. Get the eBay/Amazon API keys into your shell environment variables
  * eBay API: https://go.developer.ebay.com/
  ```shell
  export EBAY_DEVID=#YourInfo
  export EBAY_APPID_SANDBOX=#YourInfo
  export EBAY_CERTID_SANDBOX=#YourInfo
  export EBAY_APPID=#YourInfo
  export EBAY_CERTID=#YourInfo
  ```
  * Amazon API: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
  ```shell
  export AWS_ACCESS_KEY_ID=#YourInfo
  export AWS_SECRET_ACCESS_KEY=#YourInfo
  ```
4. Run rails server. `rails s`
5. Use it! To generate a request, visit this URL in your browser:
<pre>http://localhost:*port_number*/api/v1/products/*node_id*/*list_type*</pre>

The *node_id* is how Amazon refers to product categories, and you can find a [list of node id's](#amazon-node-ids) further down in the documentation. Be sure to use the number only and exclude the parentheses.

The *list_type* refers to, unsurprisingly, what type of list you want to retrieve.
For example: most gifted, most wished for, etc. See the [Amazon List Types](#amazon-list-types) section for a complete list of list types.

Once a valid request has been generated, the API will return a list of the 10 most popular products and the following attributes in JSON format.

 * Product name
 * Amazon's price
 * Link to the product on Amazon
 * eBay's price
 * Link to the product on eBay
 * Product UPC code (sourced from Amazon)

## Sample Output
```json
  {
    "title": "AmazonBasics High-Speed HDMI Cable - 6.5 Feet (2 Meters) Supports Ethernet, 3D, 4K and Audio Return",
    "az_price": 5.49,
    "az_link": "http://www.amazon.com/AmazonBasics-High-Speed-HDMI-Cable-Supports/dp/B003L1ZYYM%3Fpsc%3D1%26SubscriptionId%3DAKIAJ64U7F3OSBNH7ERQ%26tag%3Ddollarsinyour-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB003L1ZYYM",
    "upc": "848719052596",
    "ebay_price": 6.59,
    "ebay_link": "http://www.ebay.com/itm/AmazonBasics-High-Speed-HDMI-Cable-6-5-Feet-2-0-Meters-Supports-Ethernet-3D-/301291840812"
  },
  {
    "title": "$20 PlayStation Store Gift Card - PS3/ PS4/ PS Vita [Digital Code]",
    "az_price": 19.99,
    "az_link": "http://www.amazon.com/20-PlayStation-Store-Gift-Card/dp/B004RMK4BC%3Fpsc%3D1%26SubscriptionId%3DAKIAJ64U7F3OSBNH7ERQ%26tag%3Ddollarsinyour-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB004RMK4BC",
    "upc": null,
    "ebay_price": null,
    "ebay_link": null
  },
  ...
```

## Amazon Node Ids:
* Apparel & Accessories (1036592)
* Appstore for Android (2350149011)
* Arts, Crafts & Sewing (2617941011)
* Automotive (15684181)
* Baby (165796011)
* Beauty (3760911)
* Black Friday Sales (384082011)
* Books (283155)
* Camera & Photo (502394)
* Car Toys (10963061)
* Cell Phones & Accessories (2335752011)
* Computer & Video Games (468642)
* Computers (541966)
* Electronics (172282)
* Grocery & Gourmet Food (16310211)
* Health & Personal Care (3760901)
* Home & Kitchen (1055398)
* Industrial & Scientific (16310161)
* Jewelry (3367581)
* Kindle Store (133140011)
* Kitchen & Housewares (284507)
* Magazine Subscriptions (599858)
* Movies & TV (2625373011)
* MP3 Downloads (2334092011)
* Music (5174)
* Musical Instruments (11091801)
* Office Products (1064954)
* Pet Supplies (2619533011)
* Shoes (672123011)
* Software (229534)
* Sports & Outdoors (3375251)
* Tools & Hardware (228013)
* Toys and Games (165793011)
* Warehouse Deals (1267877011)

## Amazon List Types
* New Releases    (NewReleases)
* Most Gifted     (MostGifted)
* Most Wished For (MostWishedFor)
* Top Sellers     (TopSellers)

## Known Issues
* The Amazon product information retrieval is slow. The program must be delayed in order to avoid Amazon's per second API call restriction.
* Any item on Amazon that has an unlisted price (e.g. See price in cart) will default to null
* Amazon price does not take shipping cost into account. This is a limitation of the Amazon product advertising API, and cannot be fixed.
* Output is currently limited to 10 items
