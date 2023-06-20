import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../db/location_dao.dart';
import '../models/location_channel.dart';
import '../models/location_model.dart';

class LocationsProvider extends ChangeNotifier {
  List<LocationModel> locations = [];

  Future insertInDatabase(double latitude, double longitude) async {
    final newLocation = LocationModel(latitude: latitude, longitude: longitude);
    locations.add(newLocation);
    await LocationDao().save(LocationModel(
        latitude: newLocation.latitude, longitude: newLocation.longitude));
    notifyListeners();
  }

  Stream<List<LocationModel>> readFromDatabase() async* {
    final taskList = await LocationDao().findAll();
    locations = taskList;
    yield locations;
  }

  Future deleteAllFromDatabase() async {
    await LocationDao().deleteAll();
    locations.clear();
    notifyListeners();
  }

  Future<LocationModel?> getLocation() async {
    final LocationChannel channel = LocationChannel();

    final locationFromNative = await channel.getLocation();

    if (locationFromNative != null) {

      var loc = json.decode(locationFromNative);

      var latitude = double.parse(loc['LATITUDE']);
      var longitude = double.parse(loc['LONGITUDE']);

      final LocationModel location = LocationModel(latitude: latitude, longitude: longitude);

      insertInDatabase(latitude, longitude);

      return location;
    }
    return null;
  }

}
