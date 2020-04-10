import 'dart:async';

import 'package:qrreaderapp/scr/bloc/validator.dart';
import 'package:qrreaderapp/scr/models/scan_model.dart';
import 'package:qrreaderapp/scr/providers/db_provider.dart';
class ScansBloc with Validators{
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //obtener scans de la bd
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream      => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp  => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }


  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());

  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async {
      DBProvider.db.deleteAll();
      obtenerScans();
  }
}