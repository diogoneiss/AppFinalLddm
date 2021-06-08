import 'package:app_criptomoedas/model/exchange_model.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/service/exchange_service.dart';
import 'package:app_criptomoedas/database/market_dao.dart';
import 'package:meta/meta.dart';

class Repository {
  Future<List<ExchangeModel>> getExchanges() async {
    return await Service().getExchanges();
  }

  Future<List<MarketModel>> getMarkets(
      {@required ExchangeModel exchange}) async {
    return await Service().getMarkets(exchange: exchange);
  }

  Future<MarketModel> getSummary({@required MarketModel market}) async {
    MarketModel marketModel = await Service().getSummary(market: market);
    marketModel.selected =
        await MarketDao().isMarketFavorite(market: marketModel);

    return marketModel;
  }

  Future<void> createOrUpdate({@required MarketModel market}) async {
    await MarketDao().createOrUpdate(market: market);
  }

  Future<void> delete({@required MarketModel market}) async {
    await MarketDao().delete(market: market);
  }

  Future<List<MarketModel>> markets() async {
    List<MarketModel> markets = await MarketDao().markets();
    List<MarketModel> list = [];
    for (var market in markets) {
      MarketModel mm = await getSummary(market: market);
      mm.selected = true;
      list.add(mm);
    }

    return list;
  }
}
