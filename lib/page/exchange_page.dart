import 'package:flutter/material.dart';
import 'package:app_criptomoedas/bloc/bloc.dart';
import 'package:app_criptomoedas/model/exchange_model.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/component/market_card.dart';

class Exchange extends StatefulWidget {
  static const String routeName = '/exchange';

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  ExchangeModel _exchange;
  MarketModel _market;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addCoin',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adição de moeda'),
        ),
        body: Container(
          child: Center(
            child: RefreshIndicator(
              onRefresh: () => bloc.refreshExchanges(),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _getExchanges(),
                    _getMarkets(),
                    _getCard(),
                    SizedBox(
                      height: 20,
                    ),
                    _saveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getExchanges() {
    return StreamBuilder<List<ExchangeModel>>(
        stream: bloc.exchangeSubject,
        builder: (context, AsyncSnapshot<List<ExchangeModel>> snapshot) {
          List<DropdownMenuItem<ExchangeModel>> _items = [];
          if (snapshot.hasData) {
            _items = snapshot.data
                .map<DropdownMenuItem<ExchangeModel>>((ExchangeModel model) {
              return DropdownMenuItem<ExchangeModel>(
                value: model,
                child: Text(model.name),
              );
            }).toList();

            return DropdownButtonFormField<ExchangeModel>(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: false,
                labelText: 'Escolha uma corretora',
              ),
              items: _items,
              onChanged: (ExchangeModel newValue) {
                bloc.getMarkets(model: newValue);
                setState(() {
                  _exchange = newValue;
                });
              },
              value: _exchange,
            );
          } else {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                padding: EdgeInsets.all(50),
              ),
            );
          }
        });
  }

  Widget _getMarkets() {
    return StreamBuilder<List<MarketModel>>(
        stream: bloc.marketSubject,
        builder: (context, AsyncSnapshot<List<MarketModel>> snapshot) {
          List<DropdownMenuItem<MarketModel>> _items = [];
          if (snapshot.hasData) {
            _items = snapshot.data
                .map<DropdownMenuItem<MarketModel>>((MarketModel model) {
              return DropdownMenuItem<MarketModel>(
                value: model,
                child: Text(model.pair),
              );
            }).toList();

            return DropdownButtonFormField<MarketModel>(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: false,
                labelText: 'Escolha agora um asset',
              ),
              items: _items,
              onChanged: (MarketModel newValue) {
                bloc.getSummary(model: newValue);
                setState(() {
                  _market = newValue;
                });
              },
              value: _market,
            );
          } else {
            if (_exchange != null) {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  padding: EdgeInsets.all(50),
                ),
              );
            } else {
              return Container(
                child: null,
              );
            }
          }
        });
  }

  Widget _getCard() {
    return StreamBuilder<MarketModel>(
      stream: bloc.summarySubject,
      builder: (context, AsyncSnapshot<MarketModel> snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            child: SizedBox(
              height: 120,
              child: MarketCard(
                marketModel: snapshot.data,
              ),
            ),
            onWillPop: () async {
              bloc.removeData();
              return new Future(() => true);
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          if (_market != null) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                padding: EdgeInsets.all(50),
              ),
            );
          } else {
            return Container(
              child: null,
            );
          }
        }
      },
    );
  }

  Widget _saveButton() {
    return StreamBuilder<MarketModel>(
        stream: bloc.summarySubject,
        builder: (context, AsyncSnapshot<MarketModel> snapshot) {
          if (snapshot.hasData) {
            return RawMaterialButton(
              padding: EdgeInsets.all(5.0),
              onPressed: () async {
                await bloc.saveSummary(market: snapshot.data);
                await bloc.removeData();
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 8),
                child: Text('Salvar'),
              ),
              fillColor: Theme.of(context).buttonColor,
              splashColor: Theme.of(context).splashColor,
              shape: StadiumBorder(),
            );
          } else {
            return Container(
              child: null,
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    bloc.getExchanges();
  }
}
