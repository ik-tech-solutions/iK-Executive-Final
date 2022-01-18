
import 'package:firebase_database/firebase_database.dart';

class LogisticaExtra{


  String key;
  String latitudeColeta;
  String longitudeColeta;
  String latitudeEntrega;
  String longitudeEntrega;
  String preco;
  String referencia;
  String taxaEnvio;
  String taxaCobranca;
  String uidCliente;

  String destinatario;
  String remetente;
  String distancia;
  String duracao;
  String endereco_destino;
  String endereco_origem;
  String data;
  String observacao;
  String tipo;
  String carro;
  String estado;
  String nome_motorista;
  String token_motorista;
  String pagamento;
  String inicio;
  String tipoDeCasa;
  String custo_da_distancia;
  String regiao;
  String tipo_de_cliente;
  List<dynamic> servico_adicional;
  List<dynamic> artigos;




  LogisticaExtra({
    this.key,
    this.latitudeColeta,
    this.longitudeColeta,
    this.latitudeEntrega,
    this.longitudeEntrega,
    this.preco,
    this.referencia,
    this.taxaEnvio,
    this.taxaCobranca,

    this.destinatario,
    this.remetente,
    this.distancia,
    this.duracao,
    this.endereco_destino,
    this.endereco_origem,
    this.data,
    this.observacao,
    this.tipo,
    this.carro,
    this.servico_adicional,
    this.estado,
    this.nome_motorista,
    this.token_motorista,
    this.artigos,
    this.pagamento,
    this.inicio,
    this.tipoDeCasa,
    this.custo_da_distancia,
    this.uidCliente,
    this.regiao,
    this.tipo_de_cliente
  });

  LogisticaExtra.fromSnapshot(DataSnapshot snapshot){

     key = snapshot.value['key'];
     latitudeColeta= snapshot.value['latitude_origem'];
     longitudeColeta = snapshot.value['longitude_origem'];
     latitudeEntrega = snapshot.value['latitude_destino'];
     longitudeEntrega = snapshot.value['longitude_destino'];
     preco = snapshot.value['custo'];
     referencia = snapshot.value['referencia'];
     taxaEnvio = snapshot.value['taxa_envio'];
     taxaCobranca = snapshot.value['taxa_cobranca'];

     destinatario = snapshot.value['destinatario'];
     remetente = snapshot.value['nome_usuario'];
     distancia = snapshot.value['distancia'];
     duracao = snapshot.value['duracao'];
     endereco_destino = snapshot.value['endereco_destino'];
     endereco_origem = snapshot.value['endereco_origem'];
     data = snapshot.value['data'];
     observacao = snapshot.value['observacao'];
     tipo = snapshot.value['tipo'];
     carro = snapshot.value['carro'];
     servico_adicional = snapshot.value['servico_adicional'];
     estado = snapshot.value['status'];

     nome_motorista = snapshot.value['nome_motorista'];
     token_motorista = snapshot.value['token_motorista'];
     pagamento      = snapshot.value['pagamento'];
     artigos        = snapshot.value['artigos'];

     inicio         = snapshot.value['inicio'];
     tipoDeCasa     = snapshot.value['tipo_casa'];
     custo_da_distancia     = snapshot.value['custo_da_distancia'];
     uidCliente     = snapshot.value['id_usuario'];
     regiao     = snapshot.value['regiao'];

     tipo_de_cliente = snapshot.value['tipo_usuario'];
  }

}