import 'package:firebase_database/firebase_database.dart';

class Usuario{
  String id;
  String nomecompleto;
  String email;
  String telefone;
  String imagemPerfil;
  String token;
  String status;
  String device_id;
  String company_key;

  Usuario({
    this.email,
    this.nomecompleto,
    this.id,
    this.telefone,
    this.imagemPerfil,
    this.token,
    this.status,
    this.device_id,
    this.company_key,
  });

  Usuario.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.value['uid'];
    telefone = snapshot.value['phone'];
    email = snapshot.value['email'];
    nomecompleto = snapshot.value['nome'];
    imagemPerfil = snapshot.value['imagemPerfil'];
    token = snapshot.value['token'];
    device_id = snapshot.value['device_token'];
    status = snapshot.value['status'];
    company_key = snapshot.value['company_key'];
  }
}