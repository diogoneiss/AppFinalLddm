import 'package:app_criptomoedas/model/quote_model.dart';

class PairModel {
  QuoteModel base;
  QuoteModel quote;

  PairModel({this.base, this.quote});

  factory PairModel.fromJson(Map<String, dynamic> json) => PairModel(
        base: QuoteModel.fromJason(json['base']),
        quote: QuoteModel.fromJason(json['quote']),
      );
}
