import 'package:app_criptomoedas/database/database_provider.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:meta/meta.dart';

class MarketDao extends DatabaseProvider {
  Future<void> createOrUpdate({@required MarketModel market}) async {
    final db = await database;

    await db.delete(DatabaseProvider.SUMMARY,
        where: 'id = ?', whereArgs: [market.id]);

    await db.insert(DatabaseProvider.SUMMARY, market.toJson());
  }

  Future<void> delete({@required MarketModel market}) async {
    final db = await database;

    await db.delete(DatabaseProvider.SUMMARY,
        where: 'id = ?', whereArgs: [market.id]);
  }

  Future<bool> isMarketFavorite({@required MarketModel market}) async {
    final db = await database;

    var res = await db.query(DatabaseProvider.SUMMARY,
        where: 'id = ?', whereArgs: [market.id]);

    return res.isNotEmpty;
  }

  Future<List<MarketModel>> markets() async {
    final db = await database;

    final List<Map<String, dynamic>> markets =
        await db.query(DatabaseProvider.SUMMARY);

    return List.generate(markets.length, (i) {
      return MarketModel.fromJson(markets[i]);
    });
  }

//  Future<List<DominioModel>> getAll() async {
//    final db = await database;
//    var res = await db.query(TABELA_SEXO);
//    List<DominioModel> list =
//    res.isNotEmpty ? res.map((c) => DominioModel.fromJson(c)).toList() : [];
//    return list;
//  }

}
