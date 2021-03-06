import 'package:flutter/material.dart';
import 'package:qrreaderapp/scr/bloc/scans_bloc.dart';
import 'package:qrreaderapp/scr/models/scan_model.dart';
import 'package:qrreaderapp/scr/utils/utils.dart' as utils;
import 'package:qrscan/qrscan.dart';

class DireccionesPage extends StatelessWidget {
final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream:scansBloc.scansStreamHttp,
      builder: (context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final scans = snapshot.data;
        if (scans.length == 0)
          return Center(
            child: Text("No hay Informacion"),
          );
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            onDismissed: (direccion)=>scansBloc.borrarScan(scans[i].id),
            background: Container(color:Colors.red,),
            key:UniqueKey(),
            child: ListTile(
              onTap:()=> utils.abrirScan(context,scans[i]),
              leading: Icon(Icons.cloud_queue),
              title: Text(scans[i].valor),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.arrow_back),
            ),
          ),
        );
      },
    );
  }
}
