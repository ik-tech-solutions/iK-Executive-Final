import 'package:firebase_database/firebase_database.dart';

class Carteira{

  String ganho_total;
  String taxa_total;
  String desconto_total;

  Carteira({
    this.ganho_total,
    this.taxa_total,
    this.desconto_total
  });

  Carteira.fromSnapshot(DataSnapshot snapshot){
    ganho_total = snapshot.value['ganho_total'];
    taxa_total = snapshot.value['taxa_total'];
    desconto_total = snapshot.value['desconto_total'];
  }
}