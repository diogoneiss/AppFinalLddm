import 'package:app_criptomoedas/bloc/bloc.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/page/exchange_page.dart';
import 'package:flutter/material.dart';
import 'package:app_criptomoedas/component/market_list_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de criptomoedas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gerenciador de criptomoedas'),
      routes: {
        Exchange.routeName: (context) => Exchange(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  bool _confirmDismiss = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'adicionarMoeda',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Exchange.routeName);
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: RefreshIndicator(
          onRefresh: () => bloc.markets(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<List<MarketModel>>(
                stream: bloc.favoritesSubject,
                builder: (context, AsyncSnapshot<List<MarketModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15.0),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) {
                          return MarketListItem(
                            item: snapshot.data[position],
                            onEdit: _handleEdit,
                            onDelete: _handleDelete,
                            dismissDirection: DismissDirection.startToEnd,
                            confirmDismiss: _confirmDismiss,
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    if (snapshot.data == null) {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit(MarketModel item) {
    //TODO Edit code here!
  }

  void _handleDelete(MarketModel item) {
    bloc.deleteSummary(market: item);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Você apagou o item ${item.exchange} / ${item.pair}'),
      action: SnackBarAction(
        label: 'desfazer',
        onPressed: () {
          handleUndo(item);
        },
      ),
    ));
  }

  void handleUndo(MarketModel item) {
    bloc.saveSummary(market: item..selected = true);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.markets();
  }
}
