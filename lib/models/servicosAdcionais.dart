

import 'package:firebase_database/firebase_database.dart';

class ServicoAdicional{

  String _nome;
  String _custo;

  String nome1;
  String custo1;

  ServicoAdicional({
    this.nome1,
    this.custo1
  });

  ServicoAdicional.fromSnapshot(DataSnapshot snapshot){
    nome1 = snapshot.value['nome'];
    custo1 = snapshot.value['custo'];
  }


  String get envio => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get custo => _custo;

  set custo(String value) {
    _custo = value;
  }



}