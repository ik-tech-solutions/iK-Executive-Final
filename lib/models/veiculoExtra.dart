
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/constance/global.dart';

class VeiculoExtra{


  String ano;
  String classe;
  String cor;
  String marca;
  String modelo;
  String nif;
  String placa;
  String taxa_envio;
  String transportadora;




  VeiculoExtra({
    this.ano,
    this.classe,
    this.cor,
    this.marca,
    this.modelo,
    this.nif,
    this.placa,
    this.taxa_envio,
    this.transportadora,


  });

  VeiculoExtra.fromSnapshot(DataSnapshot snapshot){

    ano = snapshot.value['ano'];
    classe= snapshot.value['classe'];
    cor = snapshot.value['cor'];
    marca = snapshot.value['marca'];
    modelo = snapshot.value['modelo'];
    nif = snapshot.value['nif'];
    placa = snapshot.value['placa'];
    taxa_envio = snapshot.value['taxa_envio'];
    transportadora = snapshot.value['transportadora'];



  }

}