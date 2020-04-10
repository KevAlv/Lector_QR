import 'package:flutter/material.dart';
import 'package:qrreaderapp/scr/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
   final MapController map =  new MapController();

   String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.my_location), onPressed: () {
            map.move(scan.getLatLng(), 15); 
          })
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
        options: new MapOptions(
      center: scan.getLatLng(),
      zoom: 10
    ),
    layers:[
      _crearMapa(),
      _crearMarcadores(scan)
    ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
          'accessToken': 'pk.eyJ1IjoiY29uc3RydWN0b3ItMSIsImEiOiJjazhuNjdib3kwNm1mM2xxbzVjbnJ1dm9xIn0.ai20Kcet0LbJLfKcfGPrdw',
          'id'         : 'mapbox.$tipoMapa'
      }

    );
  }

  _crearMarcadores(ScanModel scan) {
      return MarkerLayerOptions(
          markers: <Marker>[
            Marker(
               width: 100,
               height: 100,
               point: scan.getLatLng(),
               builder: (context)=>Container(
                 child: Icon(Icons.location_on,size: 45,color: Colors.black87,),
               )
            )
          ]
      );
  }

  Widget _crearBotonFlotante(BuildContext context) {
      return FloatingActionButton(
        onPressed:(){
          if(tipoMapa=='streets'){
            tipoMapa = 'dark';
          }else if(tipoMapa=='dark'){
             tipoMapa = 'light';
          }else if(tipoMapa=='light'){
             tipoMapa = 'outdoors';
          }else if(tipoMapa=='outdoors'){
             tipoMapa = 'satelite';
          }else{
             tipoMapa = 'streets';
          }
          setState(() {
            
          });

        },
        child: Icon(Icons.repeat),

      );
  }
}
