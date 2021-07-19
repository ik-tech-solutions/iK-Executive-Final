import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/data/methods.dart';
import 'package:my_cab_driver/models/veiculo.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNewVehical extends StatefulWidget {
  @override
  _AddNewVehicalState createState() => _AddNewVehicalState();
}

// const String userToken =  currentUserInfo.token;

class _AddNewVehicalState extends State<AddNewVehical> {

  String dropdownValueClasseDeCarro = "Escolha a sua classe";
  List <String> spinnerItemClasseDeCarro = [];

  final FirebaseAuth authFB = FirebaseAuth.instance;

  var txtmodelo = TextEditingController();
  var txtmarca = TextEditingController();
  var txtano = TextEditingController();
  var txtplaca = TextEditingController();
  var txtcor = TextEditingController();
  var txttransportadora = TextEditingController();
  var txtnif = TextEditingController();
  var txtclasse = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: appBar(),

      body: StreamBuilder(
          stream: FirebaseDatabase.instance.reference().child('motorista').child(authFB.currentUser.uid).child("veiculo").onValue,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              listaDeVeiculo.clear();
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              if(dataValues.value != null){


                  veiculo = new Veiculo.fromSnapshot(dataValues);

                  txttransportadora.text = veiculo.transportadora;
                  txtnif.text = veiculo.nif;
                  txtmarca.text = veiculo.marca;
                  txtmodelo.text = veiculo.modelo;
                  txtano.text = veiculo.ano;
                  txtplaca.text = veiculo.placa;
                  txtcor.text = veiculo.cor;
                  txtclasse.text = veiculo.classe;


                return Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16, left: 16),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Empresa transportadora'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txttransportadora,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique nome da empresa transportadora',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('NIF da empresa'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtnif,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique o NIF da empresa',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Marca do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtmarca,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a marca do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Modelo do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtmodelo,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique o modelo do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Ano de fabricação'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller:txtano,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,

                                      decoration: InputDecoration(
                                        hintText: 'Indique o ano de fabricação do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Placa do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtplaca,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a placa do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Cor de veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtcor,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a cor do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Classe do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtclasse,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a classe do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Center(
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return                  //Cadastro feito com sucesso!
                                                AlertDialog(
                                                  title: Text('Finalizando o registo...'),
                                                  content: Text('Ao clicar no PRÓXIMO, será redirecionado ao e-mail para a submissão das imagens da documentação do seu veículo.'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Cancelar'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('Próximo'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        sendMail();

                                                      },
                                                    ),
                                                  ],
                                                );
                                            },
                                          );

                                          // Navigator.push(
                                          // context,
                                          // MaterialPageRoute(
                                          // builder: (context) =>
                                          // PhoneVerification(),
                                          // ),
                                          // );
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('Submeter as imagens da documentação'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      )
                    ],
                  ),
                );

              } else {
                //NOVO CADASTRO DO VEICULO
                return Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16, left: 16),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Empresa transportadora'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txttransportadora,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique nome da empresa transportadora',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('NIF da empresa'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtnif,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique o NIF da empresa',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Marca do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtmarca,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a marca do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Modelo do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtmodelo,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique o modelo do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Ano de fabricação'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller:txtano,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),

                                      decoration: InputDecoration(
                                        hintText: 'Indique o ano de fabricação do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Placa do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtplaca,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a placa do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Cor de veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: TextFormField(
                                      controller: txtcor,
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Indique a cor do veículo',
                                        prefixIcon: Icon(
                                          Icons.car_rental,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color,
                                        ),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Classe do veículo'),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme.of(context).dividerColor),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: StreamBuilder(
                                        stream: FirebaseDatabase.instance.reference().child("tipo_veiculo").onValue,
                                        builder: (context, AsyncSnapshot<Event> snapshot) {
                                          if (snapshot.hasData) {
                                            listaDeVeiculo.clear();
                                            listaDeVeiculo.add("Escolha a sua classe");
                                            DataSnapshot dataValues = snapshot.data.snapshot;
                                            // Map<dynamic, dynamic> values = dataValues.value;
                                            if(dataValues.value != null){

                                              print('Carro disponivel: ' + dataValues.value.toString());

                                              dataValues.value.forEach((value) {
                                                if(value != null) {
                                                  listaDeVeiculo.add(value["nome"].toString() + "     h:" + value["alturaMax"].toString() + "     c:" + value["comprimentoMax"].toString() + "     " + value["custo"].toString() + "€/hora");
                                                }
                                              });
                                              return DropdownButton<String>(
                                                value: dropdownValueClasseDeCarro,
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(color: Colors.black, fontSize: 12.2),
                                                underline: Container(
                                                  height: 2,
                                                ),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    dropdownValueClasseDeCarro = data;
                                                    print("1: "+ data);
                                                    print("2: "+ listaDeVeiculo[0]);
                                                    print("3: "+ dropdownValueClasseDeCarro);
                                                  });
                                                },
                                                items: listaDeVeiculo.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 20),
                                                        child: Center(
                                                          child: Text(value, textAlign: TextAlign.center ),
                                                        ),
                                                      ));
                                                }).toList(),
                                              );

                                            } else {
                                              return Center( child: Text(
                                                "Ocorreu um erro! Entre em contacto com a equipe de suporte",
                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData.secoundryFontColor,
                                                ),
                                              ),
                                              );
                                            }
                                          }
                                          return Center( child: CircularProgressIndicator());
                                        }),



                                  ),




                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          size: 80,
                                          color: Colors.deepOrange,
                                        ),
                                        Text(
                                          AppLocalizations.of('Confirmação'),
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: Theme.of(context).textTheme.subtitle1.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                                          child: Text(
                                            AppLocalizations.of('Os dados informados não poderão ser alterados.\nConfirma a veracidade dos dados preenchidos?'),
                                            style: Theme.of(context).textTheme.caption.copyWith(
                                              color: Theme.of(context).disabledColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  AppLocalizations.of('Não'),
                                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                    color: Theme.of(context).disabledColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Theme.of(context).dividerColor,
                                                width: 0.5,
                                                height: 48,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  if(txtmarca.text.isEmpty || txtmodelo.text.isEmpty || txtano.text.isEmpty || txtplaca.text.isEmpty || txtcor.text.isEmpty || dropdownValueClasseDeCarro == "Escolha a sua classe"  || dropdownValueClasseDeCarro.isEmpty || txttransportadora.text.isEmpty || txtnif.text.isEmpty){

                                                    final snackBar = SnackBar(
                                                      content: Text('Por favor, preencha todos os campos'),
                                                      backgroundColor: Colors.deepOrange,
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                    return;
                                                  } else {
                                                    Center( child: showLoaderDialog(context));
                                                    Metodos.carRegisterRequest(context, authFB.currentUser.uid, txtmarca.text, txtmodelo.text, txtano.text, txtplaca.text, txtcor.text, dropdownValueClasseDeCarro, txttransportadora.text, txtnif.text);

                                                  }


                                                //Cadastro feito com sucesso!
                                                //    AlertDialog(
                                                //     title: Text('Finalizando o registo...'),
                                                //     content: Text('Ao clicar no PRÓXIMO, será redirecionado ao e-mail para a submissão das imagens da documentação do seu veículo.'),
                                                //     actions: <Widget>[
                                                //       FlatButton(
                                                //         child: Text('Cancelar'),
                                                //         onPressed: () {
                                                //           Navigator.of(context).pop();
                                                //         },
                                                //       ),
                                                //       FlatButton(
                                                //         child: Text('Próximo'),
                                                //         onPressed: () {
                                                //
                                                //           sendMail();
                                                //
                                                //         },
                                                //       ),
                                                //     ],
                                                //   );


                                                },
                                                child: Container(
                                                  child: Text(
                                                    AppLocalizations.of('Sim'),
                                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                      color: Theme.of(context).primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    contentPadding: EdgeInsets.only(top: 16),
                                  );
                                },
                              );

                              // Navigator.push(
                              // context,
                              // MaterialPageRoute(
                              // builder: (context) =>
                              // PhoneVerification(),
                              // ),
                              // );
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('Submeter'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      )
                    ],
                  ),
                );
              }
            }
            return Center( child: CircularProgressIndicator());
          }),

    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  sendMail() async {
    // Android and iOS
    var uri =
        'mailto:administracao@iktechsolutions.com?subject=Submissão%20de%20registo%20de%20veiculo%20-%20'+'${currentUserInfo.token}'+'&body=Querido%20Executivo!%20%20%20Junto%20ao%20email,%20anexe%20%20as%20imagens%20da%20documentação%20do%20seu%20veiculo%20e%20os%20seus%20dados%20pessoais:%20Carta%20de%20Condução,%20Documento%20de%20Registo%20do%20Veículo%20,%20Seguro,%20Alvará,%20Bilhete%20de%20Identidade%20,2%20Fotos%20do%20Veículo%20com%20a%20placa%20do%20mesmo.%20%20Obrigado!';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              child: Icon(
                Icons.arrow_back_ios,
                color: ConstanceData.secoundryFontColor,
              ),
            ),
          ),
          Text(
            AppLocalizations.of('Dados do veículo'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: ConstanceData.secoundryFontColor,
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
