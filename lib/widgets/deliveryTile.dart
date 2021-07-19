import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/request.dart';
import 'package:my_cab_driver/models/address.dart';
import 'package:my_cab_driver/models/predictions.dart';
import 'package:my_cab_driver/provider/appdata.dart';
import 'package:provider/provider.dart';


class PredictionTileDelivery extends StatelessWidget {


  final Prediction prediction;
  PredictionTileDelivery({this.prediction});
  

  void getPlaceDetails(String placeID, context)async{

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

      Provider.of<AppData>(context, listen:false).updateDestinationAddress(thisPlace);
      
      print(thisPlace.placeName);
      coletaController.text = thisPlace.placeName;
      entregaPredictionList = [];
      //Navigator.pop(context,'getDirections');
      
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        getPlaceDetails(prediction.placeId,context);
      },
      padding: EdgeInsets.all(0),
          child: Container(
            color: Color(0xFFeeeeee),
        child:Column(
          children: <Widget>[
            SizedBox(height:8),
            Row(
          children: <Widget>[
            
  
                Expanded(
                  child: Container(
                    //color: Color(0xFFdadce0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction.mainText,overflow: TextOverflow.ellipsis, style:TextStyle(fontSize:16, color: Color(0xff000000))),
                      Text(prediction.secondaryText,overflow: TextOverflow.ellipsis, style:TextStyle(fontSize:12, color: Color(0xff000000))),

                    ],),
                  ),
                )
              
          ],),
          SizedBox(height:8),
        ],)
      ),
    );
  }
}