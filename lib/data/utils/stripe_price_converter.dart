class StripePriceConverter {
  static String getStripePrice(double price) {
    final returnedPrice = (price * 100).toInt();
    return returnedPrice.toString();
  }
}
