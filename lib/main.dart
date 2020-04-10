import 'package:flutter/material.dart';
import 'package:qrreaderapp/scr/pages/despliegue_mapa_page.dart';
import 'package:qrreaderapp/scr/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'QR Reader App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes:{
        '/' : (BuildContext context)=>HomePage(),
        'mapa' : (BuildContext context)=>MapaPage()
      },
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
    
  }
}