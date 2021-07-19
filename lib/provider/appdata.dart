
import 'package:flutter/material.dart';
import 'package:my_cab_driver/models/address.dart';


class AppData extends ChangeNotifier{


  
  Address pickupAddress;

  Address destinationAddress;


  void updatePickAddress(Address pickup){
    
    pickupAddress = pickup;

    notifyListeners();
  }

  void updateDestinationAddress(Address destination){
    destinationAddress = destination;
    notifyListeners();
  }
}