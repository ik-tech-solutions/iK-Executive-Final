import 'dart:collection';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/aceptedRouteDetail.dart';
import 'package:my_cab_driver/home/rotasPendentesList.dart';
import 'package:my_cab_driver/wallet/add_event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';


class Agenda extends StatefulWidget {
  @override
  AgendaState createState() => AgendaState();
}

class AgendaState extends State<Agenda> {
  final FirebaseAuth authFB = FirebaseAuth.instance;

  DataSnapshot querySnapshot;
  dynamic data;
  List<Color> _colorCollection;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _dataDoEventoController;
  bool processing;
  CalendarController _controller;

  String _subjectText = '', _startTimeText = '', _endTimeText = '', _dateText = '',_timeDetails = '', _logistica_key = '';
  Color _headerColor, _viewHeaderColor, _calendarColor;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _initializeEventColor();
    _controller = CalendarController();

    _title = TextEditingController(text:  "");
    _dataDoEventoController = TextEditingController(text: "Data de envio");
    processing = false;
    getDataFromDatabase().then((results) {
      setState(() {
        if (results != null) {
          querySnapshot = results;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Agenda',
          ),
        ),
      ),
      body: _showCalendar(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white,),
        onPressed:() {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(),
              fullscreenDialog: true,
            ),
          );
        } ,
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
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(
                    Icons.dehaze,
                    color: ConstanceData.secoundryFontColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of('Agenda'),
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

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment || details.targetElement == CalendarElement.agenda) {

      final Meeting appointmentDetails = details.appointments[0];

      _subjectText = appointmentDetails.eventName;
      _logistica_key = appointmentDetails.resourceId;

     _dateText = DateFormat('MMMM dd, yyyy').format(appointmentDetails.from).toString();
     // _startTimeText = DateFormat('hh:mm a').format(appointmentDetails.from).toString();
     // _endTimeText = DateFormat('hh:mm a').format(appointmentDetails.to).toString();

   if (appointmentDetails.isAllDay) {
  _timeDetails = '';
     } else {
    // _timeDetails = '$_startTimeText - $_endTimeText';
     _timeDetails = '';
 }

      _logistica_key != '0001' ?    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RotaAceitaScreean(
            logisticaKey: _logistica_key,
          ),
        ),
      )
          :

  showDialog(
    context: context,
  builder: (BuildContext context) {
    return AlertDialog(
     title: Container(child: new Text('$_subjectText')),
     content: Container(
  height: 80,
   child: Column(
   children: <Widget>[
 Row(
   children: <Widget>[
    Text(
    '$_dateText',
   style: TextStyle(
   fontWeight: FontWeight.w400,
    fontSize: 20,
    ),
     ),
 ],
    ),
     Row(
    children: <Widget>[
   Text(''),
     ],
    ),
    Row(
     children: <Widget>[
     Text(_timeDetails,
     style: TextStyle(
   fontWeight: FontWeight.w400, fontSize: 15)),
   ],
     )
     ],
   ),
     ),
  actions: <Widget>[
   new FlatButton(
     onPressed: () {
    Navigator.of(context).pop();
     },
     child: new Text('Fechar')),


    ],
    );
   });
  }
  }

  _showCalendar() {
    if (querySnapshot != null) {
      List<Meeting> collection;
      var showData = querySnapshot.value;
      Map<dynamic, dynamic> values = showData;

      if (values != null) {
        List<dynamic> key = values.keys.toList();
        for (int i = 0; i < key.length; i++) {
          data = values[key[i]];
          collection ??= <Meeting>[];
          final Random random = new Random();
          collection.add(Meeting(
              eventName: data['Subject'],
              isAllDay: true,
              from: DateFormat('yyyy-MM-dd').parse(data['StartTime']),
              to: DateFormat('yyyy-MM-dd').parse(data['EndTime']),
              background: _colorCollection[random.nextInt(9)],
              resourceId: data['ResourceId']));
        }
      } else {
        final DateTime today = DateTime.now();
        return
          SfCalendar( //Sem eventos
            view: CalendarView.month,
            allowedViews: [
              CalendarView.schedule,
              CalendarView.month,
            ],
            controller: _controller,
            initialDisplayDate: DateTime(today.year, today.month, today.day),
            monthViewSettings: MonthViewSettings(showAgenda: true),
            onTap: calendarTapped,

          );

      }
      final DateTime today = DateTime.now();

      return SfCalendar(
        view: CalendarView.month,
        allowedViews: [
          CalendarView.schedule,
          CalendarView.month,
        ],
        controller: _controller,
        initialDisplayDate: DateTime(today.year, today.month, today.day),
        dataSource: _getCalendarDataSource(collection),
        monthViewSettings: MonthViewSettings(showAgenda: true),
        onTap: calendarTapped,//funcional
      );


    }
  }


  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
}

MeetingDataSource _getCalendarDataSource([List<Meeting> collection]) {
  List<Meeting> meetings = collection ?? <Meeting>[];
  List<CalendarResource> resourceColl = <CalendarResource>[];
  resourceColl.add(CalendarResource(
    displayName: 'John',
    id: '0001',
    color: Colors.red,
  ));
  return MeetingDataSource(meetings, resourceColl);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  List<Object> getResourceIds(int index) {
    return [appointments[index].resourceId];
  }
}


final FirebaseAuth authFB = FirebaseAuth.instance;
getDataFromDatabase() async {
  var value = FirebaseDatabase.instance.reference();
  var getValue = await value.child('motorista/${authFB.currentUser.uid}/calendario').once();
  return getValue;
}

class Meeting {
  Meeting(
      {this.eventName,
        this.from,
        this.to,
        this.background,
        this.isAllDay,
        this.resourceId});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String resourceId;
}