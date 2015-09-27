# TD eBay-Amazon API

## What it does

This API allows a user to find a list of the most popular products on Amazon
within a given category and compare the prices of each product to those on eBay
to determine where the best deals are between the two e-commerce giants.

## How to Use

Download the repository, bundle install, and run rails server.

Visit localhost:*port_number*/api/v1/products/*node_id*/*list_type* to generate a request.

The *node_id* is how Amazon refers to product categories, and you can find a list
of node id's further down in the documentation. Be sure to use the number only and
exclude the parentheses.

The *list_type* refers to, unsurprisingly, what type of list you want to retrieve.
For example: most gifted, most wished for, etc. See the Amazon List Types heading
for a complete list of list types.

Once a valid request has been generated, the API will return a list of the 10
most popular products and the following attributes in JSON format.

 * Product name
 * Amazon's price
 * Link to the product on Amazon
 * eBay's price
 * Link to the product on eBay
 * Product UPC code

## Sample Output
*Add output snippet here*

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
* Cell Phones & Accessories (2335753011)
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
* The Amazon product information retrieval is slow. The program must be delayed
in order to avoid Amazon's per second API call restriction.
* Any item on Amazon that has an unlisted price (e.g. See price in cart) will
default to 0
* Amazon price does not take shipping cost into account. This is a limitation of the Amazon product advertising API, and cannot be fixed.
* Output is currently limited to 10 items
