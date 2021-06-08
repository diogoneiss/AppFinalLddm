class QuoteModel {
  int id;
  String symbol;
  String name;
  bool fiat;

  QuoteModel({this.id, this.symbol, this.name, this.fiat});

  factory QuoteModel.fromJason(Map<String, dynamic> json) => QuoteModel(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        fiat: json['fiat'],
      );
}
