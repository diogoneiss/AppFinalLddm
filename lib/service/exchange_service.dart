import 'package:app_criptomoedas/service/service_provider.dart';
import 'package:app_criptomoedas/model/exchange_model.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/model/summary_model.dart';
import 'package:meta/meta.dart';
import 'package:app_criptomoedas/model/pair_model.dart';

class Service extends ServiceProvider {
  Future<List<ExchangeModel>> getExchanges() async {
    final response = await httpGet(service: 'exchanges');
    final data = response.data['result'];
    final listExchanges = data.map((json) {
      return ExchangeModel.fromJson(json);
    }).toList();
    return listExchanges.cast<ExchangeModel>();
  }

  Future<List<MarketModel>> getMarkets(
      {@required ExchangeModel exchange}) async {
    final response = await httpGet(service: 'markets/${exchange.symbol}');
    final data = response.data['result'];
    final listMarkets = data.map((json) {
      return MarketModel.fromJson(json);
    }).toList();

    return listMarkets.cast<MarketModel>();
  }

  Future<MarketModel> getSummary({@required MarketModel market}) async {
    final responseSummary = await httpGet(
        service: 'markets/${market.exchange}/${market.pair}/summary');
    final responsePairs = await httpGet(service: 'pairs/${market.pair}');
    final responseExchange =
        await httpGet(service: 'exchanges/${market.exchange}');

    final dataSummary = responseSummary.data['result'];
    final dataPairs = responsePairs.data['result'];
    final dataExchange = responseExchange.data['result'];

    market.summary = SummaryModel.fromJson(dataSummary);
    market.pairs = PairModel.fromJson(dataPairs);
    market.exchange = ExchangeModel.fromJson(dataExchange).name;

    return market;
  }
}
