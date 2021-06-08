import 'package:app_criptomoedas/model/exchange_model.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/repository/exchange_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class Bloc {
  final _exchangeSubject = BehaviorSubject<List<ExchangeModel>>();
  final _marketSubject = BehaviorSubject<List<MarketModel>>();
  final _summarySubject = BehaviorSubject<MarketModel>();
  final _favoritesSubject = BehaviorSubject<List<MarketModel>>();

  List<MarketModel> _favorites = [];

  saveSummary({@required MarketModel market}) async {
    try {
      await Repository().createOrUpdate(market: market);
      _summarySubject.sink.add(market);
      _favorites.add(market);
      _favoritesSubject.sink.add(_favorites);
    } catch (e) {
      _summarySubject.addError(e);
    }
  }

  deleteSummary({@required MarketModel market}) async {
    try {
      await Repository().delete(market: market);
      _favorites.remove(market);
      if (_favorites.isEmpty)
        _favoritesSubject.sink.add([]);
      else
        _favoritesSubject.sink.add(_favorites);
    } catch (e) {
      _summarySubject.addError(e);
    }
  }

  removeData() async {
    _summarySubject.sink.add(null);
    _marketSubject.sink.add(null);
  }

  markets() async {
    try {
      List<MarketModel> markets = await Repository().markets();
      _favorites.addAll(markets);
      _favoritesSubject.sink.add(markets);
    } catch (e) {
      _favoritesSubject.addError(e);
    }
  }

  getExchanges() async {
    if (!_exchangeSubject.hasValue) {
      refreshExchanges();
    }
  }

  refreshExchanges() async {
    try {
      _exchangeSubject.sink.add(null);
      List<ExchangeModel> exchanges = await Repository().getExchanges();
      exchanges.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      _exchangeSubject.sink.add(exchanges);
    } catch (e) {
      _exchangeSubject.addError(e);
    }
  }

  getMarkets({@required ExchangeModel model}) async {
    try {
      _marketSubject.sink.add(null);
      List<MarketModel> markets =
          await Repository().getMarkets(exchange: model);
      markets.sort((a, b) {
        return a.pair.toLowerCase().compareTo(b.pair.toLowerCase());
      });
      _marketSubject.sink.add(markets);
    } catch (e) {
      _marketSubject.addError(e);
    }
  }

  getSummary({@required MarketModel model}) async {
    try {
      _summarySubject.sink.add(null);
      MarketModel market = await Repository().getSummary(market: model);
      _summarySubject.sink.add(market);
    } catch (e) {
      _summarySubject.addError(e);
    }
  }

  dispose() {
    _exchangeSubject.close();
    _marketSubject.close();
    _summarySubject.close();
    _favoritesSubject.close();
  }

  get exchangeSubject => _exchangeSubject.stream;
  get marketSubject => _marketSubject.stream;
  get summarySubject => _summarySubject.stream;
  get favoritesSubject => _favoritesSubject.stream;
}

final bloc = Bloc();
