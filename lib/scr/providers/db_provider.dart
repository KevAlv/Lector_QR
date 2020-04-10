import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/scr/models/scan_model.dart';
export 'package:qrreaderapp/scr/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  //crear Registros
  //Manera 1
  // nuevoScanRow(ScanModel nuevoScan) async {
  //   final db = await database;
  //   final res = await db.rawInsert(
  // "INSERT INTO Scans(id,tipo,valor) "
  //    "VALUES (${nuevoScan.id},${nuevoScan.tipo},${nuevoScan.valor})");
  //          return res
  // }

  //Manera 2
  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT Obtener Informacion
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    return res.isEmpty ? ScanModel.fromJson(res.first) : null;
  }

  // SELECT ALL Todos los Scans

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getAllScansForTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT *  FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<int>  updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans',nuevoScan.toJson(),where: 'id=?',whereArgs: [nuevoScan.id]);
    return res;
  }


  //Borrar Registros

  Future<int> deleteScan(int id) async{
      final db = await database;
      final res = await db.delete('Scans',where: 'id=?',whereArgs: [id]);
      return res;
  }

    Future<int> deleteAll() async{
      final db = await database;
      final res = await db.rawDelete('DELETE FROM Scans');
      return res;
  }
}
