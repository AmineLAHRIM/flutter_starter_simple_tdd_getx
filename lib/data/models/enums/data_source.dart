/*
* pending is the default in the backend
* after purchase a ticket the order status change to processing without saved to DB
* then order status change to completed and saved to DB
* refunded is order status after you get refund of the order and it happen instantly after the request sent
* */
enum DataSource {
  LOCAL,
  REMOTE,
}
