import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/notification/notification.dart';

class ChatScreen extends StatefulWidget {
  final String logisticaKey, referenciaDaLogistic;

  const ChatScreen({Key key, this.logisticaKey, this.referenciaDaLogistic}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

bool isDriver(String status) {
  if (status == 'driver')
    return true;
  else
    return false;
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  bool isValidate = false;

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child("chat/" + widget.logisticaKey)..orderByChild('date');
    List<Map<dynamic, dynamic>> lists = [];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appbar(),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
                  stream: dbRef.onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData) {
                      lists.clear();
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;

                      List<MessageBubble> messageBubbles = [];

                      if(dataValues.value != null){
                        values.forEach((key, values) {
                          lists.add(values);

                          final messageText = values['message'];
                          final messageSender = values["type_user"];
                          final DateTime messageTime = DateTime.parse(values["date"]);
                          // final currentUsser = values.email;

                          final messageBubble = MessageBubble(
                            sender: messageSender,
                            text: messageText,
                            time: messageTime,
                            isMe:  isDriver(values["type_user"]),
                          );
                          messageBubbles.add(messageBubble);
                          messageBubbles.sort((a , b ) => b.time.compareTo(a.time));

                        });

                        return Expanded(
                          child: ListView(
                            reverse: true,
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                            children: messageBubbles,
                          ),
                        );
                      }
                      else {
                        return Center( child:Text(
                          AppLocalizations.of('Sem mensagens'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        )
                        );
                      }
                    }
                    return Center( child: CircularProgressIndicator());
                  })
          ),

          Container(
            height: 60,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              height: 40,
              padding: EdgeInsets.only(right: 14, left: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of('Escreva a mensagem...'),
                        hintStyle:
                        Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).dividerColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        chat(messageController.text, widget.logisticaKey,
                            context);

                        messageController.clear();

                      },
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appbar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(widget.referenciaDaLogistic),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  void chat(String message, String key, BuildContext context) async {
    DatabaseReference newUserRef =
    FirebaseDatabase.instance.reference().child("chat/" + key).push();
    Map messageMap = {
      'message': message,
      'type_user': 'driver',
      'date': DateTime.now().toString()
    };
    newUserRef.set(messageMap);

    //Chamamento da funcao de envio de notificacao
    getRiderNotification(
        key,
        message,
        "${currentUserInfo.nomecompleto}");
  }

  //PUSH NOTIFICATION
  static Future<String> getRiderNotification(
      String logistica, String body, String title) async {
    FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .once()
        .then((DataSnapshot snapshot) => {
      snapshot.value.forEach(
            (key, values) {
          if (values['key'].toString() == '$logistica') {
            print('ESSSSSTTTTTTTOOOOOOOOOOOOUUUUUUUUU.........' +
                values['id_usuario'].toString());
            //Chamada do método que retorna Tokem
            getRiderDevice(
                values['id_usuario'].toString(), body, title);
          }
        },
      )
    });
  }

  //PUSH NOTIFICATION
  static Future<String> getRiderDevice(
      String riderID, String body, String title) async {
    FirebaseDatabase.instance
        .reference()
        .child('cliente')
        .once()
        .then((DataSnapshot snapshot) => {
      snapshot.value.forEach(
            (key, values) {
          values.forEach((key, values) {
            if (values['uid'].toString() == '$riderID') {
              print('FUNCIONOOOOOOOOOOOOOOOOOOOOOOOOO.........' +
                  values['device_token'].toString());
              //Chamamento do método que envia notificação
              PushNotificationService.sendNotification(
                  values['device_token'].toString(),
                  body,
                  title,
                  riderID);
            }
          });
        },
      )
    });
  }


}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${time.toString().substring(0,16)}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 9,
            ),
          ),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 3.0,
            color: isMe ? Theme.of(context).primaryColor : Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
