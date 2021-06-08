class ExchangeModel {
  String symbol;
  String name;
  bool active;

  ExchangeModel({this.symbol, this.name, this.active});

  factory ExchangeModel.fromJson(Map<String, dynamic> json) => ExchangeModel(
        symbol: json['symbol'],
        name: json['name'],
        active: json['active'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
