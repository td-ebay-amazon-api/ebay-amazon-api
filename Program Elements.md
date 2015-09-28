## Amazon (Limit 86,400 hits/day)
 1. Get most popular list (most wished for, most gifted, etc...)
 2. Parse XML into hash of products

## eBay (Limit 5000 hits/day)
For each product in az_hash
 1. Find lowest price of same product (BIN, specific category)
 2. save product name, price, link/listing id, in ebay_hash


## Data :
Join results from 2 hashes (eBay, Amazon)

```
Product 1:
  az_price, float
  az_link, string
  ebay_price, float
  ebay_link, string
  upc
```

## Output :
  Format data to JSON
