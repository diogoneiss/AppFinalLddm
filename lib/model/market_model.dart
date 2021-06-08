import 'package:app_criptomoedas/model/summary_model.dart';
import 'package:app_criptomoedas/model/pair_model.dart';

class MarketModel {
  int id;
  String exchange;
  String pair;
  bool active;
  SummaryModel summary;
  PairModel pairs;
  bool selected;

  MarketModel(
      {this.id,
      this.exchange,
      this.pair,
      this.active,
      this.pairs,
      this.selected = false});

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
        id: json['id'],
        exchange: json['exchange'],
        pair: json['pair'],
        active: json['active'],
      );

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'exchange': this.exchange,
        'pair': this.pair,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketModel &&
          runtimeType == other.runtimeType &&
          pair == other.pair;

  @override
  int get hashCode => pair.hashCode;
}
