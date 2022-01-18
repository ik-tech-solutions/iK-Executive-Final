
class Logistica{




  String _key;
  String _latitudeColeta;
  String _longitudeColeta;
  String _latitudeEntrega;
  String _longitudeEntrega;
  String _preco;
  String _referencia;
  String _taxaEnvio;
  String _taxaCobranca;

  String _destinatario;
  String _remetente;
  String _distancia;
  String _duracao;
  String _endereco_destino;
  String _endereco_origem;
  String _data;
  String _observacao;
  String _tipo;
  String _carro;
  String _estado;
  String _regiao;
  List<dynamic>  _servico_adicional;
  String _valor_inicial;
  String _tipo_de_cliente;
  String _periodo_de_entrega;


  String get periodo_de_entrega => _periodo_de_entrega;

  set periodo_de_entrega(String value) {
    _periodo_de_entrega = value;
  }

  String get tipo_de_cliente => _tipo_de_cliente;

  set tipo_de_cliente(String value) {
    _tipo_de_cliente = value;
  }

  String get regiao => _regiao;

  set regiao(String value) {
    _regiao = value;
  }

  String get valor_inicial => _valor_inicial;

  set valor_inicial(String value) {
    _valor_inicial = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  List<dynamic> get servico_adicional => _servico_adicional;

  set servico_adicional(List<dynamic> value) {
    _servico_adicional = value;
  }

  String get carro => _carro;

  set carro(String value) {
    _carro = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get observacao => _observacao;

  set observacao(String value) {
    _observacao = value;
  }

  String get remetente => _remetente;

  set remetente(String value) {
    _remetente = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get endereco_origem => _endereco_origem;

  set endereco_origem(String value) {
    _endereco_origem = value;
  }

  String get endereco_destino => _endereco_destino;

  set endereco_destino(String value) {
    _endereco_destino = value;
  }

  String get duracao => _duracao;

  set duracao(String value) {
    _duracao = value;
  }

  String get distancia => _distancia;

  set distancia(String value) {
    _distancia = value;
  }


  String get destinatario => _destinatario;

  set destinatario(String value) {
    _destinatario = value;
  }

  String get taxaCobranca => _taxaCobranca;

  set taxaCobranca(String value) {
    _taxaCobranca = value;
  }

  String get taxaEnvio => _taxaEnvio;

  set taxaEnvio(String value) {
    _taxaEnvio = value;
  }

  String get referencia => _referencia;

  set referencia(String value) {
    _referencia = value;
  }

  String get key => _key;

  set key(String value) {
    _key = value;
  }

  String get latitudeColeta => _latitudeColeta;

  set latitudeColeta(String value) {
    _latitudeColeta = value;
  }

  String get latitudeEntrega => _latitudeEntrega;

  set latitudeEntrega(String value) {
    _latitudeEntrega = value;
  }

  String get longitudeColeta => _longitudeColeta;

  set longitudeColeta(String value) {
    _longitudeColeta = value;
  }

  String get longitudeEntrega => _longitudeEntrega;

  set longitudeEntrega(String value) {
    _longitudeEntrega = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }
}