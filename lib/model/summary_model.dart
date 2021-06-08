class SummaryModel {
  double lastPrice;
  double highPrice;
  double lowPrice;
  double changePercentage;
  double changeAbsolute;
  double volume;
  double volumeQuote;

  SummaryModel(
      {this.lastPrice,
      this.highPrice,
      this.lowPrice,
      this.changePercentage,
      this.changeAbsolute,
      this.volume,
      this.volumeQuote});

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> price = json['price'];
    Map<String, dynamic> change = price['change'];

    return SummaryModel(
      lastPrice: price['last'].toDouble(),
      highPrice: price['high'].toDouble(),
      lowPrice: price['low'].toDouble(),
      changePercentage: change['percentage'].toDouble(),
      changeAbsolute: change['absolute'].toDouble(),
      volume: json['volume'].toDouble(),
      volumeQuote: json['volumeQuote'].toDouble(),
    );
  }
}
