import 'package:app_criptomoedas/model/market_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter/services.dart';

class MarketCard extends StatelessWidget {
  final MarketModel marketModel;
  final VoidCallback onPressed;

  const MarketCard({
    Key key,
    this.marketModel,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final highPrice =
        FlutterMoneyFormatter(amount: marketModel.summary.highPrice);
    final lastPrice =
        FlutterMoneyFormatter(amount: marketModel.summary.lastPrice);
    final lowPrice =
        FlutterMoneyFormatter(amount: marketModel.summary.lowPrice);
    final changePercentage =
        FlutterMoneyFormatter(amount: marketModel.summary.changePercentage);

    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: _loadImage(asset: marketModel.pairs.base.symbol),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return snapshot.data;
                    else
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      );
                  }),
            ],
          ),
          SizedBox(
            width: 245,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Exchange: ${marketModel.exchange}'),
                Text('Name: ${marketModel.pairs.base.name}'
                    ' Pair: ${marketModel.pairs.base.symbol} / ${marketModel.pairs.quote.symbol}'),
                Text('High: ${highPrice.output.nonSymbol} '
                    'Last: ${lastPrice.output.nonSymbol} '
                    'Low: ${lowPrice.output.nonSymbol}'),
                Text(
                    'Change percentage: ${changePercentage.output.nonSymbol}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Image> _loadImage({@required String asset}) async {
    String path = 'assets/images/icons/$asset.png';
    return rootBundle.load(path).then((value) {
      return Image.memory(
        value.buffer.asUint8List(),
        fit: BoxFit.scaleDown,
        width: 60,
        height: 60,
      );
    }).catchError((_) {
      return Image.asset(
        "assets/images/icons/placeholder.png",
        fit: BoxFit.scaleDown,
        width: 60,
        height: 60,
      );
    });
  }
}
