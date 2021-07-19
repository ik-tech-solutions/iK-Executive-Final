
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/wallet/agenda.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key key}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _dataDoEventoController;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  final FirebaseAuth authFB = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text:  "");
    _dataDoEventoController = TextEditingController(text: "Data do evento");
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                  (value.isEmpty) ? "Escreva o título" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Título",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text(_dataDoEventoController.text, textAlign: TextAlign.center,),
                subtitle: Text("Clique aqui para escolher a data", style: TextStyle(fontSize: 10, color: Colors.pink), textAlign: TextAlign.center,),
                onTap: () async{
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildBottomPicker(
                        CupertinoDatePicker(
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newDateTime) {
                            print("Your Selected Date: ${newDateTime.day}");
                            setState(() => _dataDoEventoController.text =  newDateTime.toString().substring(0,16));
                          },
                          maximumYear: 2025,
                          minimumYear: 2021,
                        ),
                      );
                    },
                  );

                },
              ),

              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {

                        if(_dataDoEventoController.text != "Data do evento"){

                          setState(() {
                            processing = true;
                          });



                          final dbRef =
                          await FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/calendario');
                          dbRef.push().set({
                            "StartTime": _dataDoEventoController.text,
                            "EndTime": _dataDoEventoController.text,
                            "Subject": _title.text,
                            "ResourceId": '0001'
                          }).then((_) async {

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Adicionado com sucesso"),
                            ));


                          }).catchError((onError) { print(onError);


                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Agenda(),
                              fullscreenDialog: true,
                            ),
                          );

                          // Navigator.pop(context);

                          setState(() {
                            processing = false;
                          });

                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Informe a data do evento..."),
                              ));
                        }

                      }
                    },
                    child: Text(
                      "Salvar",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 20,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height + 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Agenda(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: ConstanceData.secoundryFontColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of('Adicionar Evento'),
              style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: ConstanceData.secoundryFontColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height + 40,
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _title.dispose();
    _dataDoEventoController.dispose();
    super.dispose();
  }
}