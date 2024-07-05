import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DetectorPays extends ChangeNotifier {


  String? _detectedCountryCode;
  String? _detectedCountry;

  // Getters

  String? get detectedCountryCode => _detectedCountryCode;
  String? get detectedCountry => _detectedCountry;

  // Setter with two parameters
  void setDetectedCountryAndCode(String? country, String? countryCode) {
    _detectedCountry = country;
    _detectedCountryCode = countryCode;
    notifyListeners();
  }

}
