import 'package:firebase_database/firebase_database.dart';

class Veiculo{
  String transportadora;
  String nif;
  String marca;
  String modelo;
  String ano;
  String placa;
  String cor;
  String classe;

  Veiculo({
    this.transportadora,
    this.nif,
    this.marca,
    this.modelo,
    this.ano,
    this.placa,
    this.cor,
    this.classe
  });

  Veiculo.fromSnapshot(DataSnapshot snapshot){
    transportadora = snapshot.value['transportadora'];
    nif = snapshot.value['nif'];
    marca = snapshot.value['marca'];
    modelo = snapshot.value['modelo'];
    ano = snapshot.value['ano'];
    placa = snapshot.value['placa'];
    cor = snapshot.value['cor'];
    classe = snapshot.value['classe'];
  }

}