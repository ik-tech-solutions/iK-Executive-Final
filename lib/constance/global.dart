import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_cab_driver/Language/LanguageData.dart';
import 'package:my_cab_driver/models/diretionsDetails.dart';
import 'package:my_cab_driver/models/predictions.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/models/veiculo.dart';
import 'package:my_cab_driver/models/taxas.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';
import 'package:my_cab_driver/models/servicosAdcionais.dart';
import 'package:my_cab_driver/models/veiculoExtra.dart';

bool isOffline = false;
LocationData posicaoActual;
GoogleMapController controllerHome;
var isLight = true;
var primaryRiderColorString = '#e9055c';
var primaryDarkColorString = "#e9055c";
AllTextData allTextData;
Locale locale;

void setNotificationControlBlock() async {}

FirebaseAuth auth;
final FirebaseAuth authFB = FirebaseAuth.instance;
User user;

String mapKeyANDROID = "AIzaSyDFehHeNx1VksCxQ4UTDQUPiL7f_hJ2_RE";
String serverToken =
    "AAAAZZEIerk:APA91bE5y4deGEp3bwB5R7r7EoZcJ3U-rcDWTtb-mX-3XEE-04F2OmfowhnFXOsaTodvSOJREKp6GqfKxWmQtqea1C_jlAJ1g7Nmo4GiDwretXjCHtkVFF3WJjoz1RmM3ODq1Fu_5ZH9";

var coletaController = TextEditingController();
var entregaController = TextEditingController();

List<dynamic> listaDeFeriados = [];
final horasDeTrabalhoComAumento = [
  20,
  21,
  22,
  23,
  00,
  01,
  02,
  03,
  04,
  05,
  06,
  07,
  08
];

int count_de_periodos_ja_ocupados =0;

List<Prediction> coletaPredictionList = [];
List<Prediction> entregaPredictionList = [];
List<String> listaDeVeiculo = [];
List<String> listaDeLocaisDeActuacao = [];

List<String> listaDeAlturaVeiculo = [];
List<String> listaDeCustoVeiculo = [];
List<String> listaDeTaxaVeiculo = [];
List<String> listaDeComprimentoVeiculo = [];
List<String> listaDeServicosAdicionaisNome = [];
List<String> listaDeServicosAdicionaisCusto = [];
List<String> listaDeArtigosCarregados = [];
List<String> listaDeTiposDeCasasNome = [];
List<String> listaDeTiposDeCasasCusto = [];
List<Map<dynamic, dynamic>> listaDeNotificacoes = [];
List<Map<dynamic, dynamic>> listaLogistica = [];
List<Map<dynamic, dynamic>> listaLogisticaHistorico = [];
List<Map<dynamic, dynamic>> listaLogisticaAgenda = [];

List<dynamic> listaVeiculo = [];
List<dynamic> listaServicoAdcional = [];
List<dynamic> listaArtigosEspecificos = [];

int logisticasConcluidasInt = 0;
int logisticasConcluidasIntHistorico = 0;
int logisticasPendentesInt = 0;
int logisticasDisponiveisInt = 0;
int logisticasMyWalletInt = 0;
int logisticasHistoryInt = 0;

bool resultadoDoRegistro;

DatabaseReference rideRef;
DatabaseReference notificacaoRef;

final notificacaoReFuture = FirebaseDatabase.instance
    .reference()
    .child('motorista/${authFB.currentUser.uid}/notificacoes')
    .onValue;
final historicoLogisticaReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('id_motorista')
    .equalTo(authFB.currentUser.uid)
    .onValue;
final rotasPedentesReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('id_motorista')
    .equalTo("${authFB.currentUser.uid}")
    .onValue;
final listaDeVeiculosReFuture =
    FirebaseDatabase.instance.reference().child('tipo_veiculo').onValue;
final minhasLogisticasReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('id_motorista')
    .equalTo("${authFB.currentUser.uid}")
    .onValue;
final logisticasDisponiveisReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('status')
    .equalTo("aguardando")
    .onValue;
final logisticasPendentesReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('id_motorista')
    .equalTo(authFB.currentUser.uid)
    .onValue;
final logisticasDisponiveisUmReFuture = FirebaseDatabase.instance
    .reference()
    .child('logistica')
    .orderByChild('status')
    .equalTo("aguardando")
    .limitToFirst(1)
    .onValue;

Usuario currentUserInfo;
Usuario clienteDaLogisitca;
VeiculoExtra currentCarInfo;
Carteira userCarteira;
Veiculo veiculo;
Taxa taxaDaEmpresa;
ServicoAdicional servicoAdicional;
String servicoAdicionalHelper;
Logistica logistica;
LogisticaExtra logisticaEspecifica;

String versaoDoApp;

int home_check = 0; //Variavel usado no SplashScreen para verifficar se tem uma encomenda a entregar
String home_check_LogisticKey;

String custoDoServicoAdiconalMetodos;
String ganhoTotal;
String taxa_da_plataforma_total;
String duracaoDoTrabalho;
String carroSugerido;
String maiorAltura;
String servicoAdicionalGlobal;
String dataDeEnvioGlobal;
String destinatarioGlobal;
String observacaoGlobal;
String tipoDeCasaGlobal;
String dadosDeContactoPadraoGlobal;
String dadosDeTermosPadraoGlobal;
String dadosDePoliticasPadraoGlobal;

double custo_total_provisorio = 0.0;

double custo_total_servicos_adicionais = 0.0;

int custo_adcional_da_distancia = 0;
double custo_total_adcional_da_distancia = 0;
List<String> listaDeServicosAdcionaisMultiplos = [];

DirectionDetails tripDirectionDetails;
String userid = "";
String nomeUsuario = "";
String numeroCelularUsuario = "";
String imagemPerfil = "";
String emailUsuario = "";
String tipo = "";

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(-19.833028, 34.855270),
  zoom: 16,
  //bearing: 45,
  //tilt: 45
);
