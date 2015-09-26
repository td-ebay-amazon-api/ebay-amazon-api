Amazon  (Limit 86,400 hits/day):
  Get most popular list (most wished for, most gifted, etc...)
  Parse XML into hash of products






eBay    (Limit 5000 hits/day):
  For each product in az_hash
    Find lowest price of same product (BIN, specific category)
    save product name, price, link/listing id, in ebay_hash





Data :
  Intersperse results from 2 hashes
  Product 1
    az_price, $xxx
    az_link, az_url (or w/e)
    ebay_price, $xxx
    ebay_link, ebay_url (or w/e)

Output :
  Format data to JSON
