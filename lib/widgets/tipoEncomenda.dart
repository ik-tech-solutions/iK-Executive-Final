import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';

class TipoEncomenda extends StatefulWidget {


  double tipoEncomendaHeight;
  var _titulo;
  double _tipoEncomendaHeight;

  TipoEncomenda(titulo, tipoEncomendaHeight){

    this._titulo = titulo;
    this._tipoEncomendaHeight = tipoEncomendaHeight;
    
    }

  @override
  _TipoEncomendaState createState() => _TipoEncomendaState();
}

class _TipoEncomendaState extends State<TipoEncomenda> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //var tipoEncomendaHeight = 0.0;
    
  }
}
