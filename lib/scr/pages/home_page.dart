import 'package:flutter/material.dart';
import 'package:qrreaderapp/scr/bloc/scans_bloc.dart';
import 'package:qrreaderapp/scr/models/scan_model.dart';
import 'package:qrreaderapp/scr/pages/direcciones_page.dart';
import 'package:qrreaderapp/scr/pages/mapas_page.dart';
import 'package:qrreaderapp/scr/utils/utils.dart' as utils;
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed:scansBloc.borrarScanTodos ,
          ),
        ],
      ),
      body: _callPage(_currentIndex),
      bottomNavigationBar: _buttonNavigationButtom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:()=> qrRead(context),
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  Widget _buttonNavigationButtom() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapas")),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5), title: Text("Direcciones"))
        ]);
  }

  qrRead(BuildContext context) async {
    String cameraScanResult = '';
    try {
      cameraScanResult = await scanner.scan();
    } catch (e) {
      print(e.toString());
    }
    if (cameraScanResult != null) {
      print(cameraScanResult);
    }
    if (cameraScanResult!=null) {
          final scan = ScanModel(valor:cameraScanResult);
          scansBloc.agregarScan(scan);
           utils.abrirScan(context, scan);
    }
   
    
  }
}
