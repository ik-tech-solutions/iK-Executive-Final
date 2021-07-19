import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/request.dart';
import 'package:my_cab_driver/models/address.dart';
import 'package:my_cab_driver/models/predictions.dart';
import 'package:my_cab_driver/provider/appdata.dart';
import 'package:provider/provider.dart';


class PredictionTile extends StatelessWidget {


  final Prediction prediction;
  final String tipo;
  PredictionTile({this.prediction ,this.tipo});
  

  void getPlaceDetails(String placeID,String tipo, context)async{

   /*  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Por favor espere...')
      );*/
    String url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$mapKeyANDROID";

    var response = await RequestHelper.getRequest(url);

    //Navigator.pop(context);

    if(response == 'failed'){
      return;
    }

    if(response['status'] == 'OK'){
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      
      if(tipo == "coleta"){
      Provider.of<AppData>(context, listen:false).updatePickAddress(thisPlace);
      print(thisPlace.placeName);
      print("Tipo:"+tipo);
      coletaController.text = thisPlace.placeName;
      coletaPredictionList = [];
      }

      if(tipo == "entrega"){
      Provider.of<AppData>(context, listen:false).updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);
      print("Tipo:"+tipo);
      entregaController.text = thisPlace.placeName;
      entregaPredictionList = [];

      var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
      var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

      
      }
      
      
      
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        getPlaceDetails(prediction.placeId,tipo,context);
      },
      padding: EdgeInsets.all(0),
          child: Container(
            color: Color(0xFFeeeeee),
    child: SingleChildScrollView (
        child:Column(
          children: <Widget>[
            SizedBox(height:8),
            Row(
          children: <Widget>[
            
  
                Expanded(
                  child: Container(
                    //color: Color(0xFFdadce0),
                    child: SingleChildScrollView (
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction.mainText,overflow: TextOverflow.ellipsis, style:TextStyle(fontSize:10, color: Color(0xff000000))),
                      Text(prediction.secondaryText,overflow: TextOverflow.ellipsis, style:TextStyle(fontSize:8, color: Color(
                          0xff2b2b2b))),

                    ],),
                  ),
                  ),
                )
              
          ],),
          SizedBox(height:1),
        ],)
      ),
    ),);
  }
}